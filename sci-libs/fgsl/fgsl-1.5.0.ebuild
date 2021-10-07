# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic autotools toolchain-funcs

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="https://www.lrz.de/services/software/mathematik/gsl/fortran/"
SRC_URI="https://github.com/reinh-bader/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	>=sci-libs/gsl-2.6"

src_prepare() {
	default

	eautoreconf -i
	eautoconf
}

src_compile() {
	emake -j1
}

src_install() {
	default

	rm -r "${D}"/usr/share/doc/fgsl
	rm -r "${D}"/usr/share/examples
}