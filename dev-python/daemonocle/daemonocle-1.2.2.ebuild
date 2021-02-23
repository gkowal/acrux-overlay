# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A Python library for creating super fancy Unix daemons"
HOMEPAGE="https://github.com/jnrbsn/daemonocle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 ~x86"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-python/click
	dev-python/psutil"
RDEPEND="${DEPEND}"
