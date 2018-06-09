# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic autotools toolchain-funcs

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="https://www.lrz.de/services/software/mathematik/gsl/fortran/"
SRC_URI="http://www.lrz.de/services/software/mathematik/gsl/fortran/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND=""
DEPEND="${RDEPEND}
	>=sci-libs/gsl-1.16"

src_install () {
	default

	rm -r "${D}"/usr/share/doc/fgsl
	rm -r "${D}"/usr/share/examples
}