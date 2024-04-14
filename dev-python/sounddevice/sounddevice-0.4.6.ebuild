# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Play and Record Sound with Python"
HOMEPAGE="https://github.com/spatialaudio/python-sounddevice"
KEYWORDS="amd64 x86"

LICENSE="MIT"
SLOT="0"
