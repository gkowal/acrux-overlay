# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN=github.com/influxdata/${PN}
EGO_VENDOR=(
	"cloud.google.com/go v0.47.0 github.com/googleapis/google-cloud-go"
	"collectd.org v0.3.0 github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
	"github.com/alecthomas/kingpin 947dcec5ba9c011838740e680966fd7087a71d0d"
	"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
	"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
	"github.com/apache/arrow af6fa24be0dbbc021e0844c63d1c0b89fb23a95c"
	"github.com/apex/log v1.1.0"
	"github.com/aws/aws-sdk-go v1.25.16"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/blakesmith/ar 8bd4349a67f2533b078dbc524689d15dba0f4659"
	"github.com/bmizerany/pat 6226ea591a40176dd3ff9cd8eff81ed6ca721a00"
	"github.com/boltdb/bolt v1.3.1"
	"github.com/c-bata/go-prompt v0.2.1"
	"github.com/caarlos0/ctrlc v1.0.0"
	"github.com/campoy/unique 88950e537e7e644cd746a3102037b5d2b723e9f5"
	"github.com/cespare/xxhash v1.0.0"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
	"github.com/dgryski/go-bitstream 3522498ce2c8ea06df73e55df58edfbfb33cfdd6"
	"github.com/eclipse/paho.mqtt.golang v1.2.0"
	"github.com/fatih/color v1.5.0"
	"github.com/glycerine/go-unsnap-stream 9f0cb55181dd3a0a4c168d3dbc72d4aca4853126"
	"github.com/go-sql-driver/mysql v1.4.1"
	"github.com/gogo/protobuf v1.1.1"
	"github.com/golang/groupcache 404acd9df4cc9859d64fb9eed42e5c026187287a"
	"github.com/golang/protobuf v1.1.0"
	"github.com/golang/snappy d9eb7a3d35ec988b8585d4a0068e462c27d28380"
	"github.com/google/go-cmp v0.2.0"
	"github.com/google/go-github dd29b543e14c33e6373773f2c5ea008b29aeac95"
	"github.com/google/go-querystring v1.0.0"
	"github.com/googleapis/gax-go v1.0.3"
	"github.com/goreleaser/archive v1.1.3"
	"github.com/goreleaser/goreleaser v0.79.2"
	"github.com/goreleaser/nfpm v0.9.7"
	"github.com/imdario/mergo v0.3.6"
	"github.com/influxdata/changelog d2664f8a12e3964090409ac8456763c798055df0"
	"github.com/influxdata/flux v0.50.2"
	"github.com/influxdata/influxql v1.0.1"
	"github.com/influxdata/line-protocol a3afd890113fb9f0337e05808bb06fb0ca4c685a"
	"github.com/influxdata/roaring fc520f41fab6dcece280e8d4853d87a09a67f9e0"
	"github.com/influxdata/tdigest bf2b5ad3c0a925c44a0d2842c5d8182113cd248e"
	"github.com/influxdata/usage-client 6d3895376368aa52a3a81d2a16e90f0f52371967"
	"github.com/jmespath/go-jmespath c2b33e84"
	"github.com/jstemmer/go-junit-report v0.9.1"
	"github.com/jsternberg/markdownfmt c2a5702991e37f837f84104a79fa48fd215d0458"
	"github.com/jsternberg/zap-logfmt v1.0.0"
	"github.com/jwilder/encoding b4e1701a28efcc637d9afcca7d38e495fe909a09"
	"github.com/kisielk/gotool v1.0.0"
	"github.com/klauspost/compress v1.4.0"
	"github.com/klauspost/cpuid ae7887de9fa5d2db4eaa8174a7eff2c1ac00f2da"
	"github.com/klauspost/crc32 cb6bfca970f6908083f26f39a79009d608efd5cd"
	"github.com/klauspost/pgzip 0bf5dcad4ada2814c3c00f996a982270bb81a506"
	"github.com/lib/pq v1.0.0"
	"github.com/masterminds/semver v1.4.2"
	"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-isatty v0.0.4"
	"github.com/mattn/go-runewidth v0.0.2"
	"github.com/mattn/go-tty 13ff1204f104d52c3f7645ec027ecbcf9026429e"
	"github.com/mattn/go-zglob v0.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/mitchellh/go-homedir v1.0.0"
	"github.com/mschoch/smat 90eadee771aeab36e8bf796039b8c261bebebe4f"
	"github.com/opentracing/opentracing-go bd9c3193394760d98b2fa6ebb2291f0cd1d06a7d"
	"github.com/paulbellamy/ratecounter v0.2.0"
	"github.com/peterh/liner 8c1271fcf47f341a9e6771872262870e1ad7650c"
	"github.com/philhofer/fwd v1.0.0"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/term bffc007b7fd5a70e20e28f5b7649bb84671ef436"
	"github.com/prometheus/client_golang 661e31bf844dfca9aeba15f27ea8aa0d485ad212"
	"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
	"github.com/prometheus/common 7600349dcfe1abd18d72d3a1770870d9800a7801"
	"github.com/prometheus/procfs ae68e2d4c00fed4943b5f6698d504a5fe083da8a"
	"github.com/retailnext/hllpp 101a6d2f8b52abfc409ac188958e7e7be0116331"
	"github.com/satori/go.uuid v1.2.0"
	"github.com/segmentio/kafka-go v0.2.2"
	"github.com/shurcooL/go 7189cc372560f641a5c041d2b199d9b0a41293c4"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/spf13/cast v1.3.0"
	"github.com/tinylib/msgp v1.0.2"
	"github.com/willf/bitset v1.1.3"
	"github.com/xlab/treeprint d6fb6747feb6e7cfdc44682a024bddf87ef07ec2"
	"go.opencensus.io v0.22.1 github.com/census-instrumentation/opencensus-go"
	"go.uber.org/atomic v1.3.2 github.com/uber-go/atomic"
	"go.uber.org/multierr v1.1.0 github.com/uber-go/multierr"
	"go.uber.org/zap v1.9.0 github.com/uber-go/zap"
	"golang.org/x/crypto a2144134853fc9a27a7b1e3eb4f19f1a76df13c9 github.com/golang/crypto"
	"golang.org/x/exp 69215a2ee97e88b0d79235b7aae60dc2bfa3d034 github.com/golang/exp"
	"golang.org/x/lint 16217165b5de779cb6a5e4fc81fa9c1166fda457 github.com/golang/lint"
	"golang.org/x/net a680a1efc54dd51c040b3b5ce4939ea3cf2ea0d1 github.com/golang/net"
	"golang.org/x/oauth2 c57b0facaced709681d9f90397429b9430a74754 github.com/golang/oauth2"
	"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
	"golang.org/x/sys ac767d655b305d4e9612f5f6e33120b9176c4ad4 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"golang.org/x/time fbb02b2291d28baffd63558aa44b4b56f178d650 github.com/golang/time"
	"golang.org/x/tools 45ff765b4815d34d8b80220fd05c79063b185ce1 github.com/golang/tools"
	"gonum.org/v1/gonum v0.6.0 github.com/gonum/gonum"
	"google.golang.org/api v0.5.0 github.com/googleapis/google-api-go-client"
	"google.golang.org/appengine v1.2.0 github.com/golang/appengine"
	"google.golang.org/genproto fedd2861243fd1a8152376292b921b394c7bef7e github.com/google/go-genproto"
	"google.golang.org/grpc v1.13.0 github.com/grpc/grpc-go"
	"gopkg.in/russross/blackfriday.v2 v2.0.1 github.com/russross/blackfriday"
	"gopkg.in/yaml.v2 v2.2.1 github.com/go-yaml/yaml"
	"honnef.co/go/tools d73ab98e7c39fdcf9ba65062e43d34310f198353 github.com/dominikh/go-tools"
	)

inherit golang-build golang-vcs-snapshot systemd user

GITHUB_BRANCH="1.7"
GITHUB_COMMIT="f46f63d4"

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="systemd"

DEPEND=">=app-text/asciidoc-8.6.10
	app-text/xmlto"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

src_compile() {
	pushd "src/${EGO_PN}" > /dev/null || die
	date=`date -u --iso-8601=seconds`
	set -- env GOPATH="${S}" GOCACHE="${S}/go-build" go build -v -work -x -ldflags="-X main.version=${PV} -X main.branch=${GITHUB_BRANCH} -X main.commit=${GITHUB_COMMIT} -X main.buildTime=${date}" ./...
	echo "$@"
	"$@" || die "compile failed"
	cd man
	emake build
	popd > /dev/null
}

src_install() {
	pushd "src/${EGO_PN}" > /dev/null || die
	date=`date -u --iso-8601=seconds`
	set -- env GOPATH="${S}" go install -v -work -x -ldflags="-X main.version=${PV} -X main.branch=${GITHUB_BRANCH} -X main.commit=${GITHUB_COMMIT} -X main.buildTime=${date}" ./...
	echo "$@"
	"$@" || die
	dobin "${S}"/bin/influx
	dobin "${S}"/bin/influx_*
	dosbin "${S}"/bin/influxd
	dodoc CHANGELOG.md README.md QUERIES.md etc/config.sample.toml
	doman man/*.1
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	insinto /etc/logrotate.d
	newins scripts/logrotate influxdb
	insinto "/etc/${PN}"
	newins etc/config.sample.toml "${PN}.conf"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"
	fowners influxdb:influxdb "/var/lib/${PN}"
	fowners influxdb:influxdb "/var/log/${PN}"
	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi
	popd > /dev/null || die
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
