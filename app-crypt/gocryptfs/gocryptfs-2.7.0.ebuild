# Copyright 2016-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/ https://github.com/rfjakob/gocryptfs"
SRC_URI="https://github.com/rfjakob/${PN}/releases/download/v${PV}/${PN}_v${PV}_src-deps.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}_v${PV}_src-deps"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

BDEPEND=">=dev-lang/go-1.26.0"
RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"

src_compile() {
	./build.bash || die
}

src_install() {
	emake "DESTDIR=${ED}" install
	einstalldocs
	rm -rf "${ED}"/usr/share/licenses || die
}
