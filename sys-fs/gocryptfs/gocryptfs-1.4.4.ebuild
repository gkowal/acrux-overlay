# Copyright 2016-2017 Grzegorz Kowal <grzegorz@gkowal.info>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

GITHUB_USER="rfjakob"
GITHUB_REPO="gocryptfs"
GITHUB_BRANCH="master"
GITHUB_TAG="v${PV}"
GITHUB_COMMIT="9c86daf4"
EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}"
GITHUB_PATH="${P}/src/${EGO_PN}"

DESCRIPTION="Encrypted overlay filesystem written in Go."
HOMEPAGE="https://nuetzlich.net/gocryptfs/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=dev-lang/go-1.5
	dev-vcs/git"

src_unpack() {
	unset http_proxy
	GOPATH="${S}" go get "${EGO_PN}"
	cd "${GITHUB_PATH}"
	git checkout -B production "tags/${GITHUB_TAG}"
	[ ${GITHUB_COMMIT} == `git rev-parse --short=8 HEAD` ] || die "Couldn't revert to commit ${GITHUB_COMMIT}"
	cd "${S}"
	GOPATH="${S}" go get "${EGO_PN}"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-ignore-dot-files-and-directories.patch"
	default
}

src_compile() {
	cd "${WORKDIR}/${GITHUB_PATH}"
	GOPATH="${S}" ./build.bash
}

src_install() {
	dobin bin/${PN}
	doman ${FILESDIR}/${PN}.1
	cd "${WORKDIR}/${GITHUB_PATH}"
	dodoc README.md ./Documentation/MANPAGE.md
}
