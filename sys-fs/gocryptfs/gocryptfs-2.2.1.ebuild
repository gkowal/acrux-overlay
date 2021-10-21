# Copyright 2016-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/hanwen/go-fuse/v2 v2.1.1-0.20210825171523-3ab5d95a30ae"
	"github.com/hanwen/go-fuse/v2 v2.1.1-0.20210825171523-3ab5d95a30ae/go.mod"
	"github.com/jacobsa/crypto v0.0.0-20190317225127-9f44e2d11115"
	"github.com/jacobsa/crypto v0.0.0-20190317225127-9f44e2d11115/go.mod"
	"github.com/jacobsa/oglematchers v0.0.0-20150720000706-141901ea67cd"
	"github.com/jacobsa/oglematchers v0.0.0-20150720000706-141901ea67cd/go.mod"
	"github.com/jacobsa/oglemock v0.0.0-20150831005832-e94d794d06ff"
	"github.com/jacobsa/oglemock v0.0.0-20150831005832-e94d794d06ff/go.mod"
	"github.com/jacobsa/ogletest v0.0.0-20170503003838-80d50a735a11"
	"github.com/jacobsa/ogletest v0.0.0-20170503003838-80d50a735a11/go.mod"
	"github.com/jacobsa/reqtrace v0.0.0-20150505043853-245c9e0234cb"
	"github.com/jacobsa/reqtrace v0.0.0-20150505043853-245c9e0234cb/go.mod"
	"github.com/kylelemons/godebug v0.0.0-20170820004349-d65d576e9348"
	"github.com/kylelemons/godebug v0.0.0-20170820004349-d65d576e9348/go.mod"
	"github.com/pkg/xattr v0.4.3"
	"github.com/pkg/xattr v0.4.3/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rfjakob/eme v1.1.2"
	"github.com/rfjakob/eme v1.1.2/go.mod"
	"github.com/sabhiram/go-gitignore v0.0.0-20201211210132-54b8a0bf510f"
	"github.com/sabhiram/go-gitignore v0.0.0-20201211210132-54b8a0bf510f/go.mod"
	"github.com/spf13/pflag v1.0.5"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.6.1"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"golang.org/x/crypto v0.0.0-20210817164053-32db794688a5"
	"golang.org/x/crypto v0.0.0-20210817164053-32db794688a5/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20210813160813-60bc85c4be6d"
	"golang.org/x/net v0.0.0-20210813160813-60bc85c4be6d/go.mod"
	"golang.org/x/sync v0.0.0-20201207232520-09787c993a3a/go.mod"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
	"golang.org/x/sys v0.0.0-20201101102859-da207088b7d1/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/sys v0.0.0-20210817190340-bfb29a6856f2"
	"golang.org/x/sys v0.0.0-20210817190340-bfb29a6856f2/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b"
	"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

S="${WORKDIR}/${PN}_v${PV}_src"

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/"
SRC_URI="https://github.com/rfjakob/${PN}/releases/download/v${PV}/${PN}_v${PV}_src.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-ignore-dot-files-and-directories-v2.0.patch"
	"${FILESDIR}/${PN}-do-not-make-manpage-v2.0.patch"
)

src_install() {
	dobin "${PN}"
	newman "${FILESDIR}/${P}.man" "${PN}.1"
}
