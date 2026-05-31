# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Google Antigravity CLI binary"
HOMEPAGE="https://antigravity.google"
BUILD_ID="6260531212976128"
SRC_URI="https://storage.googleapis.com/antigravity-public/antigravity-cli/${PV}-${BUILD_ID}/linux-x64/cli_linux_x64.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"

LICENSE="Google-Antigravity"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	# Install the binary, renaming it to 'agy' as expected by install.sh and the user environment
	newbin antigravity agy
}
