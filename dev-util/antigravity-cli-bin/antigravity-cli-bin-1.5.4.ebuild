# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Google Antigravity CLI binary"
HOMEPAGE="https://antigravity.google https://github.com/google-antigravity/antigravity-cli"
SRC_URI="https://github.com/google-antigravity/antigravity-cli/releases/download/${PV}/agy_cli_linux_x64.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"

LICENSE="Google-Antigravity"
SLOT="0"
KEYWORDS="amd64"

src_install() {
	# Install the binary, renaming it to 'agy' as expected by install.sh and the user environment
	newbin antigravity agy
}
