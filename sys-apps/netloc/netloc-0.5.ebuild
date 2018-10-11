# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib eapi7-ver

MY_PV=v$(ver_cut 1-2)

DESCRIPTION="Portable Network Locality (netloc)"
HOMEPAGE="http://www.open-mpi.org/projects/netloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-libs/jansson
	sys-apps/hwloc"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-jansson="${EPREFIX}/usr" \
		--with-hwloc="${EPREFIX}/usr"
}
