# Copyright 2016-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rfjakob/gocryptfs"
EGO_VENDOR=(
	"github.com/conejoninja/hid 3a959b87ebefc18767a31fa567eea402eb37239e"
	"github.com/conejoninja/tesoro e0e839b6a6f14bce56d1bfac9a86311a1646a6a3"
	"github.com/hanwen/go-fuse 95c6370914ac7822973d1893680e878e156f8d70"
	"github.com/jacobsa/crypto c73681c634de898c869684602cf0c0d2ce938c4d"
	"github.com/pkg/xattr f5b647e257e19d63831e7c7adb95dfb79d9ff4d9"
	"github.com/rfjakob/eme 2222dbd4ba467ab3fc7e8af41562fcfe69c0d770"
	"github.com/trezor/trezord-go bae9c40e5d71c459bde056d42d4b19ab318c90c2"
	"github.com/xaionaro-go/cryptoWallet 47f9f6877e4324a8bc47fc5661c32d2fe6d29586"
	"github.com/zserge/hid c86e7adeabafd6fcb3371ad64d6ed366b04d55db"
	"golang.org/x/crypto de0752318171da717af4ce24d0a2e8626afaeb11 github.com/golang/crypto"
	"golang.org/x/protobuf b4deda0973fb4c70b50d226b1af49f3da59f5265 github.com/golang/protobuf"
	"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
	"golang.org/x/sys 14742f9018cd6651ec7364dc6ee08af0baaa1031 github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-ignore-dot-files-and-directories.patch"
)

src_install() {
	dobin "${PN}"
	newman "${FILESDIR}/${P}.man" "${PN}.1"
}