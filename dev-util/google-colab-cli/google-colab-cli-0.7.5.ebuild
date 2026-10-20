# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Command-line interface for Google Colab runtimes and execution"
HOMEPAGE="
	https://github.com/googlecolab/google-colab-cli
	https://pypi.org/project/google-colab-cli/
"
SRC_URI="
	https://github.com/googlecolab/google-colab-cli/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.29.2[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.49.1[${PYTHON_USEDEP}]
	>=dev-python/google-auth-oauthlib-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/html2text-2024.2.26[${PYTHON_USEDEP}]
	>=dev-python/jupyter-kernel-client-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.10.4[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.52[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.12.5[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
	>=dev-python/rich-14.3.3[${PYTHON_USEDEP}]
	>=dev-python/typer-0.24.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-1.6[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
