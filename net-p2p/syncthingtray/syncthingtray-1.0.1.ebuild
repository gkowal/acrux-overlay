# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Tray application and Dolphin/Plasma integration for Syncthing"
HOMEPAGE="https://github.com/Martchus/syncthingtray"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 ~x86"
SLOT="1"
LICENSE="GPL-2"

RDEPEND="
	>=dev-qt/qtcore-5.6
	>=dev-qt/qtdbus-5.6
	>=dev-qt/qtgui-5.6
	>=dev-qt/qtnetwork-5.6
	>=dev-qt/qtsvg-5.6
	>=dev-qt/qtwebengine-5.6
	>=dev-qt/qtwidgets-5.6
	dev-util/cpp-utilities
	dev-util/qtutilities
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake_src_configure
}
