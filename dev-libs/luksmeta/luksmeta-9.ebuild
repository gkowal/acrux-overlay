# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A simple library for storing metadata in the LUKSv1 header"
HOMEPAGE="https://github.com/latchset/luksmeta/"

SRC_URI="https://github.com/latchset/luksmeta/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=sys-fs/cryptsetup-1.5.1
"

src_prepare() {
	default
	eautoreconf
}
