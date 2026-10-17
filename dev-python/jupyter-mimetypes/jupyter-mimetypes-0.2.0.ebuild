# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

COMMIT="463143eb4e4a988dffdefb0363e3cfaeee3a96ec"

DESCRIPTION="Enhanced Jupyter representation capabilities through proxy objects"
HOMEPAGE="
	https://github.com/datalayer/jupyter-mimetypes
	https://pypi.org/project/jupyter-mimetypes/
"
SRC_URI="
	https://github.com/datalayer/jupyter-mimetypes/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/pyarrow[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-timeout )
distutils_enable_tests pytest
