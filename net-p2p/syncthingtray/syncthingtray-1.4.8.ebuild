# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tray application for Syncthing"
HOMEPAGE="https://github.com/Martchus/syncthingtray"
SRC_URI="https://github.com/Martchus/syncthingtray/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="kde qml script static-libs systemd webengine"

REQUIRED_USE="
	qml? ( !script )
	script? ( !qml )
"

RDEPEND="
	dev-libs/openssl:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-util/qtforkawesome
	>=dev-util/cpp-utilities-5.22.0
	>=dev-util/qtutilities-6.13.0
	kde? (
		kde-frameworks/kio:5
		kde-frameworks/plasma:5
	)
	qml? ( dev-qt/qtdeclarative:5 )
	script? ( dev-qt/qtscript:5 )
	systemd? ( dev-qt/qtdbus:5 )
	webengine? ( dev-qt/qtwebengine:5 )
"
DEPEND="${RDEPEND}
	kde? (
		kde-frameworks/extra-cmake-modules:5
	)
"

RESTRICT="mirror test" #tests want to access network

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
		-DWEBVIEW_PROVIDER="$(usex webengine webengine none)"
		-DJS_PROVIDER="$(usex qml qml $(usex script script none))"
		-DSYSTEMD_SUPPORT=$(usex systemd)
		-DNO_FILE_ITEM_ACTION_PLUGIN=$(usex !kde)
		-DNO_PLASMOID=$(usex !kde)
	)
	cmake_src_configure
}
