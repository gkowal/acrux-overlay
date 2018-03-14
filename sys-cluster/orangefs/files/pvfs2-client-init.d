#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

PVFS2_CLIENT_USE_KERNEL=${PVFS2_CLIENT_USE_KERNEL:-"yes"}
PVFS2_CLIENT_PID=${PVFS2_CLIENT_PID:-"/var/run/pvfs2-client.pid"}
PVFS2_CLIENT_CORE=${PVFS2_CLIENT_CORE:-"/usr/sbin/pvfs2-client-core"}
PVFS2_CLIENT_PING=${PVFS2_CLIENT_PING:-"/usr/bin/pvfs2-ping"}
PVFS2_CLIENT_LOG=${PVFS2_CLIENT_LOG:-"/var/log/pvfs2/client.log"}
PVFS2_CLIENT_FSTAB=${PVFS2_CLIENT_FSTAB:-"/etc/fstab"}
PVFS2_CLIENT_UNLOAD_MODULE=${PVFS2_CLIENT_UNLOAD_MODULE:-"yes"}
PVFS2_CLIENT_CHECK_MAX_FAILURE=${PVFS2_CLIENT_CHECK_MAX_FAILURE:-5}
PVFS2_CLIENT_FORCE_UMOUNT=${PVFS2_CLIENT_FORCE_UMOUNT:-"no"}
PVFS2_CLIENT_NICE=${PVFS2_CLIENT_NICE:-""}
PVFS2_CLIENT_FUSE_OPTIONS=""

if yesno "${PVFS2_CLIENT_USE_KERNEL}"; then
    PVFS2_CLIENT=${PVFS2_CLIENT:-"/usr/sbin/pvfs2-client"}
else
    PVFS2_CLIENT=${PVFS2_CLIENT:-"/usr/bin/pvfs2fuse"}
fi

depend() {
    local need_fuse=""
    yesno "${PVFS2_CLIENT_USE_KERNEL}" || need_fuse="fuse"
    after pvfs2-server
    before pbs_mom
    need net localmount ${need_fuse}
}

start() {
    if yesno "${PVFS2_CLIENT_USE_KERNEL}"; then
        local piddir=$(dirname "${PVFS2_CLIENT_PID}")
        checkpath -d "${piddir}"

        if ! grep -qs pvfs2 /proc/filesystems; then
            ebegin "Loading pvfs2 kernel module"
            modprobe pvfs2
            eend $? "failed"
            [[ $? -ne 0 ]] && return 1
        fi

        local pvfs2_client_nice=""
        [[ -n "${PVFS2_CLIENT_NICE}" ]] && pvfs2_client_nice="--nice ${PVFS2_CLIENT_NICE}"

        ebegin "Starting pvfs2-client"
        # Don't fork the client so we can get the pid with s-s-d.
        start-stop-daemon --start --quiet --background \
            --make-pidfile --pidfile "${PVFS2_CLIENT_PID}" \
            --exec "${PVFS2_CLIENT}" ${pvfs2_client_nice} \
            -- -f -p "${PVFS2_CLIENT_CORE}" -L "${PVFS2_CLIENT_LOG}" \
            ${PVFS2_CLIENT_ARGS}
        eend $?
    else
        [[ -z "${PVFS2_CLIENT_NICE}" ]] && PVFS2_CLIENT_NICE=0
        local src mount_options=""
        # check if fuse client was installed
        if ! [[ -x "${PVFS2_CLIENT}" ]]; then
            eerror "Fuse client is not installed."
            eerror "User kernel module or rebuild orangefs with fuse support."
            return 1
        fi
    fi

    local str mp i rc=0
    ebegin "Mounting pvfs2 filesystems"
    if ! [[ -r "${PVFS2_CLIENT_FSTAB}" ]]; then
        error "${PVFS2_CLIENT_FSTAB} is not readable."
        rc=1
    else
        # grep all pvfs2 entries save for noauto
        for str in $(gawk '
        ($3 == "pvfs2" && !index($4, "noauto") && index($1, "#")!=1) { print $1 "<sep>" $2 }
        ' /etc/fstab); do
            yesno "${PVFS2_CLIENT_USE_KERNEL}" ||
                src=$(echo "${str}" | gawk -F "<sep>" '{ print $1 }')   # source
            mp=$(echo "${str}" | gawk -F "<sep>" '{ print $2 }')    # mount point
            if [[ -n ${PVFS2_CLIENT_CHECK_MAX_FAILURE} ]]; then
                for ((i=0; i<${PVFS2_CLIENT_CHECK_MAX_FAILURE}; i++)); do
                    "${PVFS2_CLIENT_PING}" -m "${mp}" >/dev/null 2>&1 && break
                    ewarn "servers for ${mp} are not ready, retrying"
                done
            fi

            if yesno "${PVFS2_CLIENT_USE_KERNEL}"; then
                # mount using kernel cilent
                mount "${mp}" || { eerror "Failed to mount ${mp}"; rc=1; }
            else
                # extract mount options from array
                if [[ -n "${PVFS2_CLIENT_FUSE_OPTIONS}" ]]; then
                    for (( i=0; i<${#PVFS2_CLIENT_FUSE_OPTIONS[*]}; i+=2 )); do
                        if [[ "${PVFS2_CLIENT_FUSE_OPTIONS[$i]}" == "${mp}" ]]; then
                            # preceding comma is required for further annection
                            mount_option=",${PVFS2_CLIENT_FUSE_OPTIONS[$((i+1))]}"
                            break
                        fi
                    done
                fi

                # mount pvfs2fuse
                nice -n "${PVFS2_CLIENT_NICE}" "${PVFS2_CLIENT}" \
                    -o allow_other,fs_spec="${src}""${mount_options}" "${mp}" ||
                    { eerror "Failed to mount ${mp}"; rc=1; }
            fi
        done
    fi
    eend ${rc}
    # pvfs2 client is useful even with failed mounts
    return 0
}

umount_gracious() {
    local lrc list
    umount "${mp}"
    lrc=$?
    if [[ ${lrc} -ne 0 ]]; then
        if yesno "${PVFS2_CLIENT_FORCE_UMOUNT}"; then
            ewarn "Normal ${mp} unmount failed. Forcing..."
            list=$(lsof -nt /mnt/cluster)
            umount -l "${mp}"
            # soft kill
            if [[ -n ${list} ]]; then
                kill ${list}
                sleep 1
                # hard kill hanged ones
                ps ${list} >/dev/null && kill -9 ${list}
                sleep 0.5
                # if some processes are still hang
                if ps ${list} >/dev/null; then
                    eerror "${mp} was not completely unmounted!"
                    eerror "leftover processes: ${list}"
                    rc=1
                else
                    lrc=0
                fi
            fi
            [[ ${lrc} -eq 0 ]] && ewarn "${mp} was forcefully unmounted"
        else
            eerror "Failed to umount ${mp}"
            rc=1
        fi
    fi
}

stop() {
    local mp rc=0 list
    ebegin "Unmounting pvfs2 filesystems"
    if ! [[ -r "/etc/mtab" ]]; then
        error "/etc/mtab is not readable."
        rc=1
    else
        if yesno "${PVFS2_CLIENT_USE_KERNEL}"; then
            list=$(gawk '($3 == "pvfs2") { print $2 }' /etc/mtab)
        else
            list=$(gawk '{ if (match($1,"pvfs2fuse.*")) print $2 }' /etc/mtab)
        fi
        # grep all pvfs2 entries save for noauto
        for mp in ${list}; do
            umount_gracious
        done
    fi
    eend ${rc}

    if yesno "${PVFS2_CLIENT_USE_KERNEL}"; then
        [[ ${rc} -ne 0 ]] && return 1

        ebegin "Stopping pvfs2-client"
        start-stop-daemon --stop --pidfile "${PVFS2_CLIENT_PID}"
        eend

        if [[ $? == 0 ]] && yesno "${PVFS2_CLIENT_UNLOAD_MODULE}"; then
            einfo "Waiting before module unload..."
            # wait for a while is recommended by pvfs2 guide
            sleep 2
            ebegin "Unloading pvfs2 kernel module"
            rmmod pvfs2
            eend $? "failed"
        fi
    fi
}
