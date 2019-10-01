# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/${PN}/${PN}"

EGO_VENDOR=(
	"github.com/AudriusButkevicius/go-nat-pmp 452c97607362b2ab5a7839b8d1704f0396b640ca"
	"github.com/AudriusButkevicius/pfilter 0.0.5"
	"github.com/AudriusButkevicius/recli v0.0.5"
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/StackExchange/wmi cbe66965904dbe8a6cd589e2298e5d8b986bd7dd"
	"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
	"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
	"github.com/beorn7/perks v1.0.1"
	"github.com/bkaradzic/go-lz4 7224d8d8f27ef618c0a95f1ae69dbb0488abc33a"
	"github.com/calmh/xdr v1.1.0"
	"github.com/ccding/go-stun be486d185f3d"
	"github.com/certifi/gocertifi a5e0173ced670013bfb649c7e806bc9529c986ec"
	"github.com/cheekybits/genny v1.0.0"
	"github.com/chmduquesne/rollinghash a60f8e7142b536ea61bb5d84014171189eeaaa81"
	"github.com/d4l3k/messagediff v1.2.1"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/flynn-archive/go-shlex 3f9db97f856818214da2e1057f8ad84803971cff"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/getsentry/raven-go v0.2.0"
	"github.com/go-kit/kit v0.8.0"
	"github.com/go-logfmt/logfmt v0.4.0"
	"github.com/go-ole/go-ole v1.2.4"
	"github.com/go-stack/stack v1.8.0"
	"github.com/gobwas/glob v0.2.3"
	"github.com/gogo/protobuf v1.3.0"
	"github.com/golang/groupcache 869f871628b6baa9cfbc11732cdf6546b17c1298"
	"github.com/golang/mock v1.3.1"
	"github.com/golang/protobuf v1.3.2"
	"github.com/golang/snappy v0.0.1"
	"github.com/google/go-cmp v0.3.0"
	"github.com/google/gofuzz v1.0.0"
	"github.com/hpcloud/tail v1.0.0"
	"github.com/jackpal/gateway v1.0.5"
	"github.com/json-iterator/go v1.1.7"
	"github.com/julienschmidt/httprouter v1.2.0"
	"github.com/kballard/go-shellquote 95032a82bc518f77982ea72343cc1ade730072f0"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pty v1.1.1"
	"github.com/kr/text v0.1.0"
	"github.com/lib/pq v1.2.0"
	"github.com/lucas-clemente/quic-go v0.12.0"
	"github.com/marten-seemann/qpack v0.1.0"
	"github.com/marten-seemann/qtls v0.3.2"
	"github.com/maruel/panicparse v1.3.0"
	"github.com/mattn/go-colorable v0.1.1"
	"github.com/mattn/go-isatty v0.0.9"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/mgutz/ansi 9520e82c474b0a04dd04f8a40959027271bab992"
	"github.com/minio/sha256-simd v0.1.0"
	"github.com/modern-go/concurrent bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
	"github.com/modern-go/reflect2 v1.0.1"
	"github.com/mwitkow/go-conntrack cc309e4a2223"
	"github.com/onsi/ginkgo v1.9.0"
	"github.com/onsi/gomega v1.6.0"
	"github.com/oschwald/geoip2-golang v1.3.0"
	"github.com/oschwald/maxminddb-golang v1.4.0"
	"github.com/petermattis/goid b0b1615b78e5ee59739545bb38426383b2cda4c9"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/prometheus/client_golang v1.1.0"
	"github.com/prometheus/client_model 14fe0d1b01d4d5fc031dd4bec1823bd3ebbe8016"
	"github.com/prometheus/common v0.6.0"
	"github.com/prometheus/procfs v0.0.4"
	"github.com/rcrowley/go-metrics cac0b30c2563378d434b5af411844adff8e32960"
	"github.com/sasha-s/go-deadlock v0.2.0"
	"github.com/shirou/gopsutil 47ef3260b6bf6ead847e7c8fc4101b33c365e399"
	"github.com/shirou/w32 bb4de0191aa4"
	"github.com/sirupsen/logrus v1.2.0"
	"github.com/stretchr/objx v0.1.1"
	"github.com/stretchr/testify v1.3.0"
	"github.com/syncthing/notify 69c7a957d3e2"
	"github.com/syndtr/goleveldb c3a204f8e965"
	"github.com/thejerf/suture v3.0.2"
	"github.com/urfave/cli v1.21.0"
	"github.com/vitrun/qart bf64b92db6b05651d6c25a3dabf2d543b360c0aa"
	"golang.org/x/crypto 9756ffdc2472 github.com/golang/crypto"
	"golang.org/x/net ba9fcec4b297 github.com/golang/net"
	"golang.org/x/sync 112230192c58 github.com/golang/sync"
	"golang.org/x/sys 749cb33beabd github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/time 9d24e82272b4 github.com/golang/time"
	"golang.org/x/tools 36563e24a262 github.com/golang/tools"
	"google.golang.org/genproto 11092d34479b github.com/googleapis/go-genproto"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6 github.com/alecthomas/kingpin"
	"gopkg.in/asn1-ber.v1 f715ec2f112d github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/check.v1 788fd78401277ebd861206a03c884797c6ec5541 github.com/go-check/check"
	"gopkg.in/fsnotify.v1 v1.4.7 github.com/fsnotify/fsnotify"
	"gopkg.in/ldap.v2 v2.5.1 github.com/go-ldap/ldap"
	"gopkg.in/tomb.v1 dd632973f1e7 github.com/go-tomb/tomb"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND=">=dev-lang/go-1.12"

src_compile() {
	export GOCACHE="${S}/go-build"
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN} || die
	go run build.go -version "v${PV}" -no-upgrade || die "build failed"
}
src_test() {
	export GOCACHE="${S}/go-build"
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN} || die
	go run build.go test || die "test failed"
}

src_install() {
	cd src/${EGO_PN} || die
	dobin bin/*
	doman man/*.[157]
	dodoc README.md AUTHORS CONTRIBUTING.md
}
