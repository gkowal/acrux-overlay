# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1

DESCRIPTION="Time synchronization for DCF77 devices using sound speakers"
HOMEPAGE="https://github.com/gkowal/dcf77-sync"
SRC_URI="https://github.com/gkowal/dcf77-sync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/sounddevice[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	local -x EPYTEST_PLUGINS=""
	epytest
}
