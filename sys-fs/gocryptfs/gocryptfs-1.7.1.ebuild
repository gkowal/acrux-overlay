# Copyright 2016-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rfjakob/gocryptfs"
EGO_VENDOR=(
	"github.com/hanwen/go-fuse 161a164844568ebf4bfaa68c90ba3a9f2914dda4"
	"github.com/jacobsa/crypto 9f44e2d11115452dad8f404f029574422855f46a"
	"github.com/pkg/xattr 7782c2d6871d6e659e1563dc19c86b845264a6fc"
	"github.com/rfjakob/eme 2222dbd4ba467ab3fc7e8af41562fcfe69c0d770"
	"github.com/sabhiram/go-gitignore d3107576ba9425fc1c85f4b3569c4631b805a02e"
	"golang.org/x/crypto a1f597ede03a7bef967a422b5b3a5bd08805a01e github.com/golang/crypto"
	"golang.org/x/sync e225da77a7e68af35c70ccbf71af2b83e6acac3c github.com/golang/sync"
	"golang.org/x/sys 61b9204099cb1bebc803c9ffb9b2d3acd9d457d9 github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-ignore-dot-files-and-directories.patch"
)

src_install() {
	dobin "${PN}"
	newman "${FILESDIR}/${P}.man" "${PN}.1"
}