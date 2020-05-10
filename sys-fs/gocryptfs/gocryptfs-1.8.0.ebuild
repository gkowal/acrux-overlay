# Copyright 2016-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/hanwen/go-fuse v1.0.1-0.20190319092520-161a16484456"
	"github.com/hanwen/go-fuse v1.0.1-0.20190319092520-161a16484456/go.mod"
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
	"github.com/pkg/xattr v0.4.1"
	"github.com/pkg/xattr v0.4.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rfjakob/eme v1.1.1"
	"github.com/rfjakob/eme v1.1.1/go.mod"
	"github.com/sabhiram/go-gitignore v0.0.0-20180611051255-d3107576ba94"
	"github.com/sabhiram/go-gitignore v0.0.0-20180611051255-d3107576ba94/go.mod"
	"github.com/stretchr/objx v0.1.0"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.5.1"
	"github.com/stretchr/testify v1.5.1/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200429183012-4b2356b1ed79"
	"golang.org/x/crypto v0.0.0-20200429183012-4b2356b1ed79/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20200324143707-d3edc9973b7e"
	"golang.org/x/net v0.0.0-20200324143707-d3edc9973b7e/go.mod"
	"golang.org/x/sync v0.0.0-20200317015054-43a5402ce75a"
	"golang.org/x/sync v0.0.0-20200317015054-43a5402ce75a/go.mod"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
	"golang.org/x/sys v0.0.0-20181021155630-eda9bb28ed51/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
	"golang.org/x/sys v0.0.0-20200501145240-bc7a7d42d5c3"
	"golang.org/x/sys v0.0.0-20200501145240-bc7a7d42d5c3/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
)

go-module_set_globals

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs/"
SRC_URI="https://github.com/rfjakob/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-ignore-dot-files-and-directories-v1.8.0.patch"
	"${FILESDIR}/${PN}-do-not-make-manpage-v1.8.0.patch"
)

src_install() {
	dobin "${PN}"
	newman "${FILESDIR}/${P}.man" "${PN}.1"
}
