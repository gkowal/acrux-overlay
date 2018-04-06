# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ompP is a profiling tool for OpenMP applications."
HOMEPAGE="http://www.ompp-tool.com/"
SRC_URI="http://www.ompp-tool.com/downloads/${P}.tgz"

LICENSE="GNU-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="papi"

DEPEND="papi? ( dev-libs/papi )"
RDEPEND="${DEPEND}"

src_compile() {
    emake INSTDIR=/usr OMPCC=gcc OMPFLAG=-fopenmp all
}

src_install() {
    dobin kinst/kinst-ompp
    dobin opari/tool/opari
    doheader include/*.h
    dolib lib/libompp.a
    dodoc doc/ompp-usage.pdf
    dodoc doc/ompp-usage.txt
    dodoc README
}