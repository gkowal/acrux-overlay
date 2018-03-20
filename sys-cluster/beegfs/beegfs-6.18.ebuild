# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

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

src_compile() {
	# build shared libraries
	make ${MAKEOPTS} -C beegfs_thirdparty/build
	make ${MAKEOPTS} -C beegfs_opentk_lib/build
	make ${MAKEOPTS} -C beegfs_common/build

	# build helper server
	make ${MAKEOPTS} -C beegfs_helperd/build

	# build meta server
	make ${MAKEOPTS} -C beegfs_meta/build

	# build management server
	make ${MAKEOPTS} -C beegfs_mgmtd/build

	# build storage server
	make ${MAKEOPTS} -C beegfs_storage/build

	# build utilities
	make ${MAKEOPTS} -C beegfs_utils/build
}

src_install() {
	# build shared libraries
#	make ${MAKEOPTS} -C beegfs_opentk_lib/build install
#	make ${MAKEOPTS} -C beegfs_common/build

	# build helper server
#	make ${MAKEOPTS} -C beegfs_helperd/build

	# build meta server
#	make ${MAKEOPTS} -C beegfs_meta/build

	# build management server
#	make ${MAKEOPTS} -C beegfs_mgmtd/build

	# build storage server
#	make ${MAKEOPTS} -C beegfs_storage/build

	# build utilities
#	make ${MAKEOPTS} -C beegfs_utils/build
}
