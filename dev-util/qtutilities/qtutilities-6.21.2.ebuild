# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Common Qt related C++ classes and routines"
HOMEPAGE="https://github.com/Martchus/qtutilities"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND="
	dev-qt/qtbase:6=[dbus,gui,widgets]
	>=dev-util/cpp-utilities-5.27.1:=
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6
	virtual/pkgconfig
"

RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DQT_PACKAGE_PREFIX=Qt6
	)
	cmake_src_configure
}
