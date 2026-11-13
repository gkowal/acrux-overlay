# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Agentic coding tool by Anthropic that lives in your terminal"
HOMEPAGE="
	https://github.com/anthropics/claude-code
	https://claude.com/product/claude-code
	https://code.claude.com/docs/en/overview
"
SRC_URI="
	amd64? (
		https://github.com/anthropics/claude-code/releases/download/v${PV}/claude-linux-x64.tar.gz
			-> ${P}-amd64.tar.gz
	)
	arm64? (
		https://github.com/anthropics/claude-code/releases/download/v${PV}/claude-linux-arm64.tar.gz
			-> ${P}-arm64.tar.gz
	)
"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 arm64"
RESTRICT="bindist mirror strip"

QA_PREBUILT="usr/bin/claude"
QA_PRESTRIPPED="usr/bin/claude"
QA_FLAGS_IGNORED="usr/bin/claude"

src_install() {
	dostrip -x /usr/bin/claude
	mkdir -p "${ED}/usr/bin" || die
	cp -a "${WORKDIR}/claude" "${ED}/usr/bin/claude" || die
	dosym claude /usr/bin/claude-code
}
