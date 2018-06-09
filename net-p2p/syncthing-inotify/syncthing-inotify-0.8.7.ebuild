# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

GITHUB_USER="syncthing"
GITHUB_REPO="syncthing-inotify"
GITHUB_TAG="v${PV}"
GITHUB_BRANCH="master"
GITHUB_COMMIT="f628a849"
EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}"
GITHUB_PATH="${P}/src/${EGO_PN}"

DESCRIPTION="File watcher intended for use with Syncthing"
HOMEPAGE="http://syncthing.net/"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~arm"

DEPEND=">=dev-lang/go-1.8.0"

src_unpack() {
	unset http_proxy
	export GOPATH="${S}"
	go get -v ${EGO_PN}
	cd "${GITHUB_PATH}"
	git checkout -B production "tags/${GITHUB_TAG}"
	[ ${GITHUB_COMMIT} == `git rev-parse --short=8 HEAD` ] || die "Couldn't revert to commit ${GITHUB_COMMIT}"
}

src_compile() {
	export GOPATH="${S}"
	cd "${WORKDIR}/${GITHUB_PATH}"
	date=`date -u --iso-8601=seconds`
	go build -ldflags="-w -X main.version=${PV} -X main.branch=${GITHUB_BRANCH} -X main.commit=${GITHUB_COMMIT} -X main.buildTime=${date}" ./...
}

src_install() {
	dobin bin/*
	cd "${WORKDIR}/${GITHUB_PATH}"
	dodoc README.md
}
