# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Play and Record Sound with Python"
HOMEPAGE="https://github.com/spatialaudio/python-sounddevice"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+numpy"

RDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	media-libs/portaudio
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/cffi[${PYTHON_USEDEP}]
"
