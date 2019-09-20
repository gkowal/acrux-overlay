# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Simple, configuration-driven backup software for servers and workstations"
HOMEPAGE="
	https://pypi.org/project/borgmatic/
	https://torsion.org/borgmatic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=">=dev-python/pykwalify-1.6.0
	>=dev-python/ruamel-yaml-0.15.0
	>=dev-python/colorama-0.4.1"
RDEPEND="${DEPEND}"
