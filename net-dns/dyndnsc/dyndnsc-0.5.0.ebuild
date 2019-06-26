# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Dynamic dns (dyndns) update client with support for multiple protocols"
HOMEPAGE="https://github.com/infothrill/python-dyndnsc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

DEPEND=">=dev-python/daemonocle-1.0.1
	>=dev-python/dnspython-1.15.0
	>=dev-python/netifaces-0.10.5
	>=dev-python/requests-2.0.1"
RDEPEND="${DEPEND}"