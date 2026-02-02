# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A high-performance Python interface for the analysis of AMUN code simulations"
HOMEPAGE="https://amuncode.org/ https://gitlab.com/gkowal/amunpy"
SRC_URI="https://gitlab.com/gkowal/amunpy/-/archive/v${PV}/${P}.tar.bz2"

S="${WORKDIR}/${PN}-v${PV}-be5e8893c42159621f811220e7143b2837eee47d"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/xxhash[${PYTHON_USEDEP}]
	dev-python/zstandard[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	# Ensure the src-layout is respected during testing
	local -x PYTHONPATH="${S}/src:${PYTHONPATH}"
	epytest
}
