# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Common Qt related C++ classes and routines"
HOMEPAGE="https://github.com/Martchus/qtutilities"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	>=dev-util/cpp-utilities-5.5.0
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
	)
	cmake_src_configure
}
