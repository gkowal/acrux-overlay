# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="rust-v${PV}"
MY_BASE_URI="https://github.com/openai/codex/releases/download/${MY_PV}"

DESCRIPTION="Lightweight coding agent that runs in your terminal"
HOMEPAGE="https://github.com/openai/codex"
SRC_URI="${MY_BASE_URI}/codex-x86_64-unknown-linux-musl.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

QA_PRESTRIPPED="usr/bin/codex"

src_install() {
	newbin codex-x86_64-unknown-linux-musl codex
}
