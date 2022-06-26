# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="C-language implementation of Javascript Object Signing and Encryption"
HOMEPAGE="https://github.com/latchset/jose/"

SRC_URI="https://github.com/latchset/jose/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-libs/jansson-2.10
	>=dev-libs/openssl-1.0.2
	sys-libs/zlib
"
