# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Agentic coding tool by Anthropic that lives in your terminal"
HOMEPAGE="https://claude.com/product/claude-code https://code.claude.com/docs/en/overview"

_DEB_REL="1"
SRC_URI="https://downloads.claude.ai/claude-code/apt/stable/pool/main/c/claude-code/claude-code_${PV}-${_DEB_REL}_amd64.deb -> ${P}.deb"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip"

QA_PREBUILT="usr/bin/claude"
QA_PRESTRIPPED="usr/bin/claude"
QA_FLAGS_IGNORED="usr/bin/claude"

BDEPEND="app-arch/tar"

src_unpack() {
	unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
	dostrip -x /usr/bin/claude
	mkdir -p "${ED}/usr/bin" || die
	cp -a usr/bin/claude "${ED}/usr/bin/claude" || die
	dosym claude /usr/bin/claude-code
}
