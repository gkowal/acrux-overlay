# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module bash-completion-r1

DESCRIPTION="A backup program that is fast, efficient and secure."
HOMEPAGE="https://restic.github.io/"
SRC_URI="https://github.com/restic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3-with-linking-exception MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="test"

DOCS=( CHANGELOG.md README.rst )

RDEPEND="sys-fs/fuse:0"
DEPEND="${RDEPEND}"

src_install() {
	dobin restic

	newbashcomp doc/bash-completion.sh "${PN}"

	insinto /usr/share/zsh/site-functions
	newins doc/zsh-completion.zsh _restic

	doman doc/man/*
	einstalldocs
}
