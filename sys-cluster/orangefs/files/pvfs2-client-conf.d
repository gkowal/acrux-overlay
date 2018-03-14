# There are two ways to mount pvfs2:
# 1) Using a kernel module.
# 2) Using a fuse client.
# Kernel module is recommended. Fuse should be used only when
# kernel module is unavailable or unusable.
#
# You may use fuse together with kernel client (e.g. to mount
# another filesystem using fuse), but you may use automount with
# one client only.

# By default kernel module is used, change to "no" to use fuse
# instead, you need to build OrangeFS with USE="fuse" in the latter
# case, otherwise service will fail
#PVFS2_CLIENT_USE_KERNEL="yes"

### Common options for both clients ###

# Where to fetch pvfs2 mount entries from.
# Entries with noauto option are ignored.
#PVFS2_CLIENT_FSTAB="/etc/fstab"

# Determines how many times to run pvfs2-ping check before giving
# up on a mount point. Single pvfs2-ping run takes about 10 seconds
# if server is unavailable.
#
# If you want to disable this feature, unset the following variable
# or set it to zero value.
#PVFS2_CLIENT_CHECK_MAX_FAILURE=5

# If file system is in use, forces its umount in the following steps:
# 1) Lazily umount pvfs2;
# 2) Send SIGTERM to all processes (using pvfs2 in question).
# 3) Wait for 1 second.
# 4) Send SIGKILL to all processes (using pvfs2 in question).
# Then continue stop procedures as usual.
#
# This may damage your system if some critical processes are using
# mounted pvfs2. Be careful!
#PVFS2_CLIENT_FORCE_UMOUNT="no"

# Nice priority of the client
#PVFS2_CLIENT_NICE=""

### Options for kernel client only ###

# Extra arguments to supply to the pvfs2-client daemon
#PVFS2_CLIENT_LOG="/var/log/pvfs2/client.log"

# Extra arguments to supply to the pvfs2-client daemon
#PVFS2_CLIENT_ARGS=""

# Allows to unload pvfs2 kernel module on stop
#PVFS2_CLIENT_UNLOAD_MODULE="yes"

### Options for fuse client only ###

# Mount points for kernel and fuse clients are not fully compatible
# and you may need extra options for a fuse. The following array
# contains pairs of mount poinst and their options.
# Options allow_other and fs_type are always provided.
# If nothing found, default fuse options will be used
#
# Default: empty
# Example:
# PVFS2_CLIENT_FUSE_OPTIONS=( "/mnt/pvfs2" "noatime,nodev,nosuid,intr" )
