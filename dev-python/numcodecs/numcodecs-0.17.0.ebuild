# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Buffer compression and transformation codecs for data storage"
HOMEPAGE="https://pypi.org/project/numcodecs/ https://github.com/zarr-developers/numcodecs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/numpy-2.0[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-1.6.0
	>=dev-python/cython-3.1[${PYTHON_USEDEP}]
	>=dev-python/meson-python-0.17[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
"
