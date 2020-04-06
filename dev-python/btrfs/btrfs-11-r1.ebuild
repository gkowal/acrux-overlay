# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Python 3 module to inspect btrfs filesystems"
HOMEPAGE="https://github.com/knorrie/python-btrfs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 ~x86"

LICENSE="LGPL-3"
SLOT="0"
