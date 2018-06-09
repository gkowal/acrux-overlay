# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A OS X / Windows / Linux Tray App for Syncthing written in C++"
HOMEPAGE="https://github.com/sieren/QSyncthingTray"
SRC_URI="https://github.com/sieren/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-3"
RDEPEND="
	>=dev-qt/qtcore-5.6
	>=dev-qt/qtgui-5.6
	>=dev-qt/qtnetwork-5.6
	>=dev-qt/qtprintsupport-5.6
	>=dev-qt/qtwidgets-5.6
"
DEPEND="${RDEPEND}"

src_install() {
	dodoc README.md
	cd ../${P}_build
	dobin QSyncthingTray
}