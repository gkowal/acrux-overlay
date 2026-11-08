# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Command-line interface for Drone"
HOMEPAGE="https://github.com/harness/drone-cli"
SRC_URI="https://gentoo.clarokowal.com/${CATEGORY}/${PN}/${P}.tar.xz"
SRC_URI+=" https://gentoo.clarokowal.com/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64"

BDEPEND=">=dev-lang/go-1.23.8"

RESTRICT="test"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	ego build \
		-trimpath \
		-ldflags "-X main.version=${PV}" \
		-o bin/drone ./drone
}

src_install() {
	dobin bin/drone
	einstalldocs
}
