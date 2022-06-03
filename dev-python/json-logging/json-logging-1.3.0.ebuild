# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python logging library to emit JSON log"
HOMEPAGE="https://github.com/bobbui/json-logging-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"