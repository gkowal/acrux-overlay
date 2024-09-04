# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tray application for Syncthing"
HOMEPAGE="https://github.com/Martchus/syncthingtray"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="kde qml static-libs systemd webengine"

RDEPEND="
	dev-libs/openssl:=
	dev-qt/qtconcurrent
	dev-qt/qtcore
	dev-qt/qtnetwork
	dev-qt/qtsvg
	dev-util/qtforkawesome
	dev-util/qtutilities
	kde? (
		kde-frameworks/kio
		kde-plasma/libplasma
	)
	qml? ( dev-qt/qtdeclarative )
	systemd? ( dev-qt/qtdbus )
	webengine? ( dev-qt/qtwebengine )
"
DEPEND="${RDEPEND}
	kde? (
		kde-frameworks/extra-cmake-modules
	)
"

RESTRICT="mirror test" #tests want to access network

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
		-DWEBVIEW_PROVIDER="$(usex webengine webengine none)"
		-DJS_PROVIDER="$(usex qml qml none)"
		-DSYSTEMD_SUPPORT=$(usex systemd)
		-DNO_FILE_ITEM_ACTION_PLUGIN=$(usex !kde)
		-DNO_PLASMOID=$(usex !kde)
	)
	cmake_src_configure
}
