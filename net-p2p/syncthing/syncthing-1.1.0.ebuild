# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

GITHUB_USER="syncthing"
GITHUB_REPO="syncthing"
GITHUB_TAG="v${PV}"
EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}"
GITHUB_PATH="src/${EGO_PN}"

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"
SRC_URI="https://${EGO_PN}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND=">=dev-lang/go-1.8.0"

src_compile() {
	export GOCACHE="${S}/go-build"
	cd "${GITHUB_PATH}"
	go run build.go -version "${GITHUB_TAG}" -no-upgrade || die "build failed"
}

src_test() {
	cd "${GITHUB_PATH}"
	go run build.go test || die "test failed"
}

src_install() {
	cd "${GITHUB_PATH}"
	dobin bin/*
	doman man/*.[157]
	dodoc README.md AUTHORS CONTRIBUTING.md
}
