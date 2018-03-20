# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd

DESCRIPTION="BeeGFS (formerly FhGFS) is the leading parallel cluster file system."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v6/repository/${PV}/archive.tar.bz2 -> ${P}.tar.bz2"
LICENSE="BeeGFS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="infiniband java rdma systemd"
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

src_compile() {
	# build shared libraries
	emake ${MAKEOPTS} ARCH= -C beegfs_thirdparty/build
	if use infiniband; then
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 BEEGFS_OPENTK_IBVERBS=1 -C beegfs_opentk_lib/build
	else
		emake ${MAKEOPTS} BEEGFS_DEBUG=0 BEEGFS_OPENTK_IBVERBS=0 -C beegfs_opentk_lib/build
	fi
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_common/build

	# build helper server
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_helperd/build

	# build meta server
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_meta/build

	# build management server
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_mgmtd/build

	# build storage server
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 -C beegfs_storage/build

	# build utilities
	emake ${MAKEOPTS} BEEGFS_DEBUG=0 JAVA_HOME=${JAVA_HOME} -C beegfs_utils/build
}

src_install() {
	# install shared libraries
	insinto "/etc/${PN}"
	newins "beegfs_opentk_lib/build/dist/etc/beegfs/beegfs-libopentk.conf" "beegfs-libopentk.conf"
	insinto "/usr/lib64/"
	newins "beegfs_opentk_lib/build/libbeegfs-opentk.so" "libbeegfs-opentk.so"

	# install helper server
	dosbin "beegfs_helperd/build/beegfs-helperd"
	insinto "/etc/${PN}"
	newins "beegfs_helperd/build/dist/etc/beegfs-helperd.conf" "beegfs-helperd.conf"
	if use systemd; then
		systemd_dounit "beegfs_helperd/build/dist/usr/lib/systemd/system/beegfs-helperd.service"
	fi

	# install meta server
	dosbin "beegfs_meta/build/beegfs-meta"
	dosbin "beegfs_meta/build/dist/sbin/beegfs-setup-meta"
	insinto "/etc/${PN}"
	newins "beegfs_meta/build/dist/etc/beegfs-meta.conf" "beegfs-meta.conf"
	if use systemd; then
		systemd_dounit "beegfs_meta/build/dist/usr/lib/systemd/system/beegfs-meta.service"
	fi

	# install management server
	dosbin "beegfs_mgmtd/build/beegfs-mgmtd"
	dosbin "beegfs_mgmtd/build/dist/sbin/beegfs-setup-mgmtd"
	insinto "/etc/${PN}"
	newins "beegfs_mgmtd/build/dist/etc/beegfs-mgmtd.conf" "beegfs-mgmtd.conf"
	if use systemd; then
		systemd_dounit "beegfs_mgmtd/build/dist/usr/lib/systemd/system/beegfs-mgmtd.service"
	fi

	# install storage server
	dosbin "beegfs_storage/build/beegfs-storage"
	dosbin "beegfs_storage/build/dist/sbin/beegfs-setup-storage"
	insinto "/etc/${PN}"
	newins "beegfs_storage/build/dist/etc/beegfs-storage.conf" "beegfs-storage.conf"
	if use systemd; then
		systemd_dounit "beegfs_storage/build/dist/usr/lib/systemd/system/beegfs-storage.service"
	fi

	# install utilities
	dosbin "beegfs_utils/build/beegfs-ctl"
	dosbin "beegfs_utils/build/beegfs-fsck"
	dosbin "beegfs_utils/scripts/beegfs-check-servers"
	dosbin "beegfs_utils/scripts/beegfs-df"
	dosbin "beegfs_utils/scripts/beegfs-net"
}
