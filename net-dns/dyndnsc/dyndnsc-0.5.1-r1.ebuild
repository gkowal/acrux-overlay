# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Dynamic dns (dyndns) update client with support for multiple protocols"
HOMEPAGE="https://github.com/infothrill/python-dyndnsc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 ~x86"

LICENSE="MIT"
SLOT="0"

DEPEND=">=dev-python/daemonocle-1.0.1
	>=dev-python/dnspython-1.15.0
	>=dev-python/netifaces-0.10.5
	>=dev-python/requests-2.0.1"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# dyndnsc falsely assumes it needs pytest-runner unconditionally and will
	# try to install it, causing sandbox violations.
	sed -i -e "/setup_requires=\[\"pytest-runner\"\],/d" setup.py || die

	distutils-r1_python_prepare_all
}