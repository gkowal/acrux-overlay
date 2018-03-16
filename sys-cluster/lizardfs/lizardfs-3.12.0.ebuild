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
IUSE="+fuse judy"

CDEPEND="
	app-text/asciidoc
	dev-libs/boost
	sys-devel/libtool
	sys-libs/zlib
	fuse? ( sys-fs/fuse )
	judy? ( dev-libs/judy )
"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

