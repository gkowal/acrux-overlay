# Copyright 2016-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/"
SRC_URI="https://github.com/rfjakob/${PN}/releases/download/v${PV}/${PN}_v${PV}_src-deps.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/rfjakob/${PN}/releases/download/v${PV}/${PN}_v${PV}_linux-static_amd64.tar.gz"

S="${WORKDIR}/${PN}_v${PV}_src-deps"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-ignore-dot-files-and-directories-v2.0.patch"
	"${FILESDIR}/${PN}-do-not-make-manpage-v2.0.patch"
)

src_install() {
	default
	newman "${WORKDIR}/${PN}.1" "${PN}.1"
	newman "${WORKDIR}/${PN}-xray.1" "${PN}-xray.1"
}
