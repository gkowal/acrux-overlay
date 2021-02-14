# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Automated Encryption Framework"
HOMEPAGE="https://github.com/latchset/clevis/"

SRC_URI="https://github.com/latchset/clevis/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	app-crypt/tpm2-tools
	app-misc/jq
	app-shells/bash-completion
	dev-libs/jose
	dev-libs/libpwquality
	dev-libs/luksmeta
	sys-process/audit
"

PATCHES=(
	"${FILESDIR}/${P}-systemd.patch"
)
