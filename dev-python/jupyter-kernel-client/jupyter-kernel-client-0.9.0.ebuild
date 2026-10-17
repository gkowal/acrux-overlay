# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

COMMIT="f18e982c3265df5e923aa9def101ab3fd737e139"

DESCRIPTION="Jupyter Kernel Client through HTTP and WebSocket"
HOMEPAGE="
	https://github.com/googlecolab/jupyter-kernel-client
	https://github.com/datalayer/jupyter-kernel-client
	https://pypi.org/project/jupyter-kernel-client/
"
SRC_URI="
	https://github.com/googlecolab/jupyter-kernel-client/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-8.6.3[${PYTHON_USEDEP}]
	>=dev-python/jupyter-mimetypes-0.1.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.3[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	# Bump version in _version.py to match 0.9.0 required by google-colab-cli
	sed -i -e "s/__version__ = .*/__version__ = \"${PV}\"/" jupyter_kernel_client/_version.py || die
}
