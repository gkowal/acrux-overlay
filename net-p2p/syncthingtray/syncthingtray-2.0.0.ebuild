# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tray application for Syncthing"
HOMEPAGE="https://github.com/Martchus/syncthingtray"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="kde static-libs systemd webengine"

DEPEND="
	>=dev-util/cpp-utilities-5.30.0:=
	>=dev-util/qtforkawesome-0.0.3:=
	>=dev-util/qtutilities-6.17.0:=
	dev-qt/qtbase:6=[gui,network,widgets]
	dev-qt/qtsvg:6=
	kde? (
		dev-qt/qtdeclarative:6=
		kde-frameworks/kio:6=
		kde-plasma/libplasma:6=
	)
	systemd? ( dev-qt/qtbase:6=[dbus] )
	webengine? (
		dev-qt/qtdeclarative:6=
		dev-qt/qtwebengine:6=
	)
"
RDEPEND="${DEPEND}
	net-p2p/syncthing
"

RESTRICT="mirror test" #tests want to access network

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
		-DWEBVIEW_PROVIDER="$(usex webengine webengine none)"
		-DJS_PROVIDER="$(usex webengine qml none)"
		-DSYSTEMD_SUPPORT=$(usex systemd)
		-DNO_FILE_ITEM_ACTION_PLUGIN=$(usex !kde)
		-DNO_PLASMOID=$(usex !kde)
		-DQT_PACKAGE_PREFIX=Qt6
		-DKF_PACKAGE_PREFIX=KF6
	)
	cmake_src_configure
}
