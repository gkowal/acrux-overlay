# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="LizardFS is an Open Source Distributed File System"
HOMEPAGE="https://lizardfs.com/"
SRC_URI="https://github.com/lizardfs/lizardfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	app-text/asciidoc
	dev-libs/boost
	dev-libs/judy
	sys-devel/libtool
	sys-fs/fuse
	sys-libs/db
	sys-libs/pam
	sys-libs/zlib
"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/
		-DDEFAULT_USER=nobody
		-DDEFAULT_GROUP=nobody
		-DENABLE_POLONAISE=OFF
		-DENABLE_DEBIAN_PATHS=ON
	)

	cmake-utils_src_configure
}
