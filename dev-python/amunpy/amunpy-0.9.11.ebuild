# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Read snapshots written using the AMUN code"
HOMEPAGE="https://amuncode.org"
KEYWORDS="amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-python/h5py
	dev-python/lz4
	dev-python/numpy
	dev-python/xxhash
	dev-python/zstandard
"
RDEPEND="${DEPEND}"
