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

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/pykwalify-1.6.0[${PYTHON_USEDEP}]
	<dev-python/pykwalify-14.06[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.0[${PYTHON_USEDEP}]
	<dev-python/ruamel-yaml-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.1[${PYTHON_USEDEP}]
	<dev-python/colorama-0.5[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
