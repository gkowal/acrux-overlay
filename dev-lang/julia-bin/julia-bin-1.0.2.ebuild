# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"
SRC_URI="https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-${PV}-linux-x86_64.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="preserve-libs strip"

S="${WORKDIR}/julia-${PV}"

src_install() {
	# copy package files
	dodir "/opt/${P}"
	cp -pPR bin etc include lib share "${ED}/opt/${P}" || die

	# set up the environment
	echo "PATH=${EPREFIX}/opt/${P}/bin" > "${T}"/40${PN} || die
	echo "LDPATH=${EPREFIX}/opt/${P}/lib" >> "${T}"/40${PN} || die
	echo "MANPATH=${EPREFIX}/opt/${P}/share/man" >> "${T}"/40${PN} || die
	doenvd "${T}"/40${PN}
}