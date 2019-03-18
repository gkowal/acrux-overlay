# Copyright 2016-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rfjakob/gocryptfs"
EGO_VENDOR=(
	"github.com/hanwen/go-fuse a533f0a5a633cccc0928c81985b13fa24407a211"
	"github.com/jacobsa/crypto d95898ceee0769dac9bf74c46f8f68d3d3d79100"
	"github.com/pkg/xattr 7782c2d6871d6e659e1563dc19c86b845264a6fc"
	"github.com/rfjakob/eme 2222dbd4ba467ab3fc7e8af41562fcfe69c0d770"
	"golang.org/x/crypto 8dd112bcdc25174059e45e07517d9fc663123347 github.com/golang/crypto"
	"golang.org/x/sync e225da77a7e68af35c70ccbf71af2b83e6acac3c github.com/golang/sync"
	"golang.org/x/sys b6889370fb1098ed892bd3400d189bb6a3355813 github.com/golang/sys"
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