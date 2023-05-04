# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python 3 module to inspect btrfs filesystems"
HOMEPAGE="https://github.com/knorrie/python-btrfs"
SRC_URI="https://github.com/knorrie/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-3"
SLOT="0"

S="${WORKDIR}/python-${P}"
