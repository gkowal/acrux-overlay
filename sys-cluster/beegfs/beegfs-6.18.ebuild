# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils linux-mod systemd

DESCRIPTION="BeeGFS (formerly FhGFS) is the leading parallel cluster file system."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v6/repository/${PV}/archive.tar.bz2 -> ${P}.tar.bz2"
LICENSE="BeeGFS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client infiniband java management meta rdma storage systemd utils"
MY_P="v6-${PV}-aee03250ea19502952d2f187e73134996abaec5b"
S="${WORKDIR}/${MY_P}"

DEPEND="
	>=dev-db/sqlite-3.0
	dev-libs/openssl
	dev-util/cppunit
	sys-apps/attr
	sys-devel/libtool
	sys-fs/xfsprogs
	sys-libs/zlib
	infiniband? ( sys-fabric/libibverbs )
	rdma? ( sys-fabric/librdmacm )
	java? ( virtual/jdk )
"
RDEPEND="${DEPEND}"

MODULE_NAMES="beegfs(misc:${S}/beegfs_client_module/build)"

src_compile() {
	# build shared libraries
	emake ${MAKEOPTS} ARCH= -C beegfs_thirdparty/build
	if use infiniband; then
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 BEEGFS_OPENTK_IBVERBS=1 -C beegfs_opentk_lib/build
	else
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 BEEGFS_OPENTK_IBVERBS=0 -C beegfs_opentk_lib/build
	fi
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_common/build

	if use management; then
		# build management server
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_mgmtd/build
	fi

	if use meta; then
		# build meta server
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_meta/build
	fi

	if use storage; then
		# build storage server
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_storage/build
	fi

	if use utils; then
		# build utilities
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 JAVA_HOME=${JAVA_HOME} -C beegfs_utils/build
	fi

	if use client; then
		# build helper server
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_helperd/build

		# build client services and kernel module
		cd "${S}/beegfs_client_module/source"
		linux-mod_src_compile || die "failed to build driver"
	fi
}

src_install() {
	# install shared libraries
	insinto "/etc/${PN}"
	newins "beegfs_opentk_lib/build/dist/etc/beegfs/beegfs-libopentk.conf" "beegfs-libopentk.conf"
	insinto "/usr/lib64/"
	newins "beegfs_opentk_lib/build/libbeegfs-opentk.so" "libbeegfs-opentk.so"

	# install common files
	#
#	newinitd "beegfs_common_package/build/dist/etc/init.d/beegfs-service.init" "beegfs-service"
#	insinto "/etc/${PN}/lib"
#	newins "beegfs_common_package/scripts/etc/beegfs/lib/init-multi-mode" "init-multi-mode"
#	newins "beegfs_common_package/scripts/etc/beegfs/lib/start-stop-functions" "start-stop-functions"

	if use management; then
		# install management server
		dosbin "beegfs_mgmtd/build/beegfs-mgmtd"
		dosbin "beegfs_mgmtd/build/dist/sbin/beegfs-setup-mgmtd"
#		newinitd "beegfs_mgmtd/build/dist/etc/init.d/beegfs-mgmtd.init" "beegfs-mgmtd"
#		insinto "/etc/default"
#		newins "beegfs_mgmtd/build/dist/etc/default/beegfs-mgmtd" "beegfs-mgmtd"
		insinto "/etc/${PN}"
		newins "beegfs_mgmtd/build/dist/etc/beegfs-mgmtd.conf" "beegfs-mgmtd.conf"
#		if use systemd; then
#			systemd_dounit "beegfs_mgmtd/build/dist/usr/lib/systemd/system/beegfs-mgmtd.service"
#		fi
	fi

	if use meta; then
		# install meta server
		dosbin "beegfs_meta/build/beegfs-meta"
		dosbin "beegfs_meta/build/dist/sbin/beegfs-setup-meta"
#		newinitd "beegfs_meta/build/dist/etc/init.d/beegfs-meta.init" "beegfs-meta"
#		insinto "/etc/default"
#		newins "beegfs_meta/build/dist/etc/default/beegfs-meta" "beegfs-meta"
		insinto "/etc/${PN}"
		newins "beegfs_meta/build/dist/etc/beegfs-meta.conf" "beegfs-meta.conf"
#		if use systemd; then
#			systemd_dounit "beegfs_meta/build/dist/usr/lib/systemd/system/beegfs-meta.service"
#		fi
	fi

	if use storage; then
		# install storage server
		dosbin "beegfs_storage/build/beegfs-storage"
		dosbin "beegfs_storage/build/dist/sbin/beegfs-setup-storage"
#		newinitd "beegfs_storage/build/dist/etc/init.d/beegfs-storage.init" "beegfs-storage"
#		insinto "/etc/default"
#		newins "beegfs_storage/build/dist/etc/default/beegfs-storage" "beegfs-storage"
		insinto "/etc/${PN}"
		newins "beegfs_storage/build/dist/etc/beegfs-storage.conf" "beegfs-storage.conf"
#		if use systemd; then
#			systemd_dounit "beegfs_storage/build/dist/usr/lib/systemd/system/beegfs-storage.service"
#		fi
	fi

	if use utils; then
		# install utilities
		dosbin "beegfs_utils/build/beegfs-ctl"
		dosbin "beegfs_utils/build/beegfs-fsck"
		dosbin "beegfs_utils/scripts/beegfs-check-servers"
		dosbin "beegfs_utils/scripts/beegfs-df"
		dosbin "beegfs_utils/scripts/beegfs-net"
	fi

	if use client; then
		# install helper server
		dosbin "beegfs_helperd/build/beegfs-helperd"
		newinitd "beegfs_helperd/build/dist/etc/init.d/beegfs-helperd.init" "beegfs-helperd"
#		insinto "/etc/default"
#		newins "beegfs_helperd/build/dist/etc/default/beegfs-helperd" "beegfs-helperd"
		insinto "/etc/${PN}"
		newins "beegfs_helperd/build/dist/etc/beegfs-helperd.conf" "beegfs-helperd.conf"
#		if use systemd; then
#			systemd_dounit "beegfs_helperd/build/dist/usr/lib/systemd/system/beegfs-helperd.service"
#		fi

		# install client services and kernel module
		dosbin "beegfs_client_module/build/dist/sbin/beegfs-setup-client"
#		newinitd "beegfs_client_module/build/dist/etc/init.d/beegfs-client.init" "beegfs-client"
#		insinto "/etc/default"
#		newins "beegfs_client_module/build/dist/etc/default/beegfs-client" "beegfs-client"
		insinto "/etc/${PN}"
		newins "beegfs_client_module/build/dist/etc/beegfs-client.conf" "beegfs-client.conf"
#		newins "beegfs_client_module/build/dist/etc/beegfs-client-autobuild.conf" "beegfs-client-autobuild.conf"
#		newins "beegfs_client_module/build/dist/etc/beegfs-mounts.conf" "beegfs-mounts.conf"
#		if use systemd; then
#			systemd_dounit "beegfs_client_module/build/dist/usr/lib/systemd/system/beegfs-client.service"
#		fi
		cd "${S}/beegfs_client_module/source"
		linux-mod_src_install || die "failed to install driver"
	fi
}
