# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils systemd

DESCRIPTION="RGB Driver for Linux"
HOMEPAGE="https://github.com/ckb-next/ckb-next"
SRC_URI="https://github.com/ckb-next/ckb-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

DEPEND=">=dev-libs/quazip-0.7.2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

DOCS=( README.md CHANGELOG.md )

src_install() {
	cmake-utils_src_install
	if use systemd; then
		systemd_dounit "${ED}"/usr/lib/systemd/system/ckb-next-daemon.service
	fi
	rm -r "${ED}"/usr/lib
	newinitd "${FILESDIR}"/ckb-next.initd ckb-next-daemon
	insinto /lib/udev/rules.d
	doins "${ED}"/etc/udev/rules.d/99-ckb-daemon.rules
	rm -r "${ED}"/etc/udev
}