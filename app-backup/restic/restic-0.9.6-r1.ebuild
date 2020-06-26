# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 fcaps golang-vcs-snapshot

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io/"
SRC_URI="https://github.com/restic/restic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGO_PN="github.com/restic/restic"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3-with-linking-exception MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

BDEPEND="dev-lang/go"
RDEPEND="sys-fs/fuse:0"
DEPEND="acct-group/restic
        acct-user/restic
        ${RDEPEND}"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
		-ldflags "-X main.version=${PV}"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-o restic ${EGO_PN}/cmd/restic
	)

	GO111MODULE=off GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build "${mygoargs[@]}" || die
}

src_test() {
	GO111MODULE=off GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go test -timeout 30m -v -work -x ${EGO_PN}/cmd/... ${EGO_PN}/internal/... || die
}

src_install() {
	dobin restic

	fowners root:restic /usr/bin/restic
	fperms 4710 /usr/bin/restic

	newbashcomp doc/bash-completion.sh "${PN}"

	insinto /usr/share/zsh/site-functions
	newins doc/zsh-completion.zsh _restic

	doman doc/man/*
	dodoc doc/*.rst
}

pkg_postinst() {
	fcaps cap_dac_read_search -g restic -m 4710 -M 0710 \
		"${EROOT}/usr/bin/restic"
}
