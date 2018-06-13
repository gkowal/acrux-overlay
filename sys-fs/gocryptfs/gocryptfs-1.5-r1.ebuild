# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rfjakob/gocryptfs"
EGO_VENDOR=(
	"github.com/hanwen/go-fuse 291273cb8ce0f139636a6fd7414be3c7e2de6288"
	"github.com/jacobsa/crypto c73681c634de898c869684602cf0c0d2ce938c4d"
	"github.com/pkg/xattr d15dbc2bb0b5da267362b5e066e2c44c1fcff6c7"
	"github.com/rfjakob/eme 2222dbd4ba467ab3fc7e8af41562fcfe69c0d770"
	"golang.org/x/crypto 8ac0e0d97ce45cd83d1d7243c060cb8461dda5e9 github.com/golang/crypto"
	"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
	"golang.org/x/sys a9e25c09b96b8870693763211309e213c6ef299d github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

PATCHES=(
	"${FILESDIR}/${PN}-ignore-dot-files-and-directories.patch"
)

src_install() {
	dobin ${PN}
	doman "${FILESDIR}/${PN}".1
}