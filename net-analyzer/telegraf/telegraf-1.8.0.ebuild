# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/influxdata/telegraf"
EGO_VENDOR=(
	"cloud.google.com/go 97efc2c9ffd9fe8ef47f7f3203dc60bbca547374 github.com/GoogleCloudPlatform/google-cloud-go"
	"code.cloudfoundry.org/clock 02e53af36e6c978af692887ed449b74026d76fec github.com/cloudfoundry/clock"
	"collectd.org 2ce144541b8903101fb8f1483cc0497a68798122 github.com/collectd/go-collectd"
	"github.com/Azure/go-autorest 9bc4033dd347c7f416fca46b2f42a043dc1fbdf6"
	"github.com/Microsoft/ApplicationInsights-Go d2df5d440eda5372f24fcac03839a64d6cb5f7e5"
	"github.com/Microsoft/go-winio 97e4973ce50b2ff5f09635a57e2b88a037aae829"
	"github.com/Shopify/sarama ec843464b50d4c8b56403ec9d589cf41ea30e722"
	"github.com/StackExchange/wmi 5d049714c4a64225c3c79a7cf7d02f7fb5b96338"
	"github.com/aerospike/aerospike-client-go 1dc8cf203d24cd454e71ce40ab4cd0bf3112df90"
	"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
	"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
	"github.com/amir/raidman 1ccc43bfb9c93cb401a4025e49c64ba71e5e668b"
	"github.com/apache/thrift 014f53f6582fbae8146ae291d471382016091a06"
	"github.com/aws/aws-sdk-go a8ff9e4804fc89c994b731b1c057640ab2aecff3"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/bsm/sarama-cluster c618e605e15c0d7535f6c96ff8efbb0dba4fd66c"
	"github.com/cenkalti/backoff 2ea60e5f094469f9e65adb9cd103795b73ae743e"
	"github.com/couchbase/go-couchbase 031fc5f9b18f64fe23838410d574c11c76946f93"
	"github.com/couchbase/gomemcached 20e69a1ee160444d2663130ce853ac969aec4689"
	"github.com/couchbase/goutils e865a1461c8ac0032bd37e2d4dab3289faea3873"
	"github.com/davecgh/go-spew 8991bc29aa16c548c550c7ff78260e27b9ab7c73"
	"github.com/denisenkom/go-mssqldb 1eb28afdf9b6e56cf673badd47545f844fe81103"
	"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
	"github.com/dimchansky/utfbom 5448fe645cb1964ba70ac8f9f2ffe975e61a536c"
	"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
	"github.com/docker/docker ed7b6428c133e7c59404251a09b7d6b02fa83cc2"
	"github.com/docker/go-connections 7395e3f8aa162843a74ed6d48e79627d9792ac55"
	"github.com/docker/go-units 47565b4f722fb6ceae66b95f853feed578a4a51c"
	"github.com/eapache/go-resiliency ea41b0fad31007accc7f806884dcdf3da98b79ce"
	"github.com/eapache/go-xerial-snappy 776d5712da21bc4762676d614db1d8a64f4238b0"
	"github.com/eapache/queue 44cc805cf13205b55f69e14bcb69867d1ae92f98"
	"github.com/eclipse/paho.mqtt.golang 36d01c2b4cbeb3d2a12063e4880ce30800af9560"
	"github.com/go-ini/ini 5cf292cae48347c2490ac1a58fe36735fb78df7e"
	"github.com/go-logfmt/logfmt 390ab7935ee28ec6b286364bba9b4dd6410cb3d5"
	"github.com/go-ole/go-ole a41e3c4b706f6ae8dfbff342b06e40fa4d2d0506"
	"github.com/go-redis/redis f3bba01df2026fc865f7782948845db9cf44cf23"
	"github.com/go-sql-driver/mysql d523deb1b23d913de5bdada721a6071e71283618"
	"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
	"github.com/gogo/protobuf 636bf0302bc95575d69441b25a2603156ffdddf1"
	"github.com/golang/mock c34cdb4725f4c3844d095133c6e40e448b86589b"
	"github.com/golang/protobuf aa810b61a9c79d51363740d207bb46cf8e620ed5"
	"github.com/golang/snappy 2e65f85255dbc3072edf28d6b5b8efc472979f5a"
	"github.com/google/go-cmp 3af367b6b30c263d47e8895973edcca9a49cf029"
	"github.com/google/uuid d460ce9f8df2e77fb1ba55ca87fafed96c607494"
	"github.com/gorilla/context 08b5f424b9271eedf6f9f0ce86cb9396ed337a42"
	"github.com/gorilla/mux e3702bed27f0d39777b0b37b664b6280e8ef8fbf"
	"github.com/hailocab/go-hostpool e80d13ce29ede4452c43dea11e79b9bc8a15b478"
	"github.com/hashicorp/consul 48d287ef690ada66634885640f3444dbf7b71d18"
	"github.com/hashicorp/go-cleanhttp e8ab9daed8d1ddd2d3c4efba338fe2eeae2e4f18"
	"github.com/hashicorp/go-rootcerts 6bb64b370b90e7ef1fa532be9e591a81c3493e00"
	"github.com/hashicorp/serf d6574a5bb1226678d7010325fb6c985db20ee458"
	"github.com/influxdata/go-syslog eecd51df3ad85464a2bab9b7d3a45bc1e299059e"
	"github.com/influxdata/tail c43482518d410361b6c383d7aebce33d0471d7bc"
	"github.com/influxdata/toml 2a2e3012f7cfbef64091cc79776311e65dfa211b"
	"github.com/influxdata/wlog 7c63b0a71ef8300adc255344d275e10e5c3a71ec"
	"github.com/jackc/pgx 89f1e6ac7276b61d885db5e5aed6fcbedd1c7e31"
	"github.com/jmespath/go-jmespath 0b12d6b5"
	"github.com/kardianos/osext ae77be60afb1dcacde03767a8c37337fad28ac14"
	"github.com/kardianos/service b1866cf76903d81b491fb668ba14f4b1322b2ca7"
	"github.com/kballard/go-shellquote 95032a82bc518f77982ea72343cc1ade730072f0"
	"github.com/konsorten/go-windows-terminal-sequences b729f2633dfe35f4d1d8a32385f6685610ce1cb5"
	"github.com/kr/logfmt b84e30acd515aadc4b783ad4ff83aff3299bdfe0"
	"github.com/mailru/easyjson 60711f1a8329503b04e1c88535f419d0bb440bff"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
	"github.com/miekg/dns f4db2ca6edc3af0ee51bf332099cc480bcf3ef9d"
	"github.com/mitchellh/go-homedir ae18d6b8b3205b561c79e8e5f69bff09736185f4"
	"github.com/mitchellh/mapstructure fa473d140ef3c6adf42d6b391fe76707f1f243c8"
	"github.com/multiplay/go-ts3 d0d44555495c8776880a17e439399e715a4ef319"
	"github.com/naoina/go-stringutil 6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
	"github.com/nats-io/gnatsd eed4fbc1458ce110ad1aa1adf904229bc8fda2a7"
	"github.com/nats-io/go-nats fb0396ee0bdb8018b0fef30d6d1de798ce99cd05"
	"github.com/nats-io/nuid 289cccf02c178dc782430d534e3c1f5b72af807f"
	"github.com/nsqio/go-nsq eee57a3ac4174c55924125bb15eeeda8cffb6e6f"
	"github.com/opencontainers/go-digest 279bed98673dd5bef374d3b6e4b09e2af76183bf"
	"github.com/opencontainers/image-spec d60099175f88c47cd379c4738d158884749ed235"
	"github.com/opentracing-contrib/go-observer a52f2342449246d5bcc273e65cbdcfa5f7d6c63c"
	"github.com/opentracing/opentracing-go 1949ddbfd147afd4d964a9f00b24eb291e0e7c38"
	"github.com/openzipkin/zipkin-go-opentracing 26cf9707480e6b90e5eff22cf0bbf05319154232"
	"github.com/pierrec/lz4 bb6bfd13c6a262f1943c0446eb25b7f54c1fb9a2"
	"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
	"github.com/pmezard/go-difflib 792786c7400a136282c1664665ae0a8db921c6c2"
	"github.com/prometheus/client_golang c5b7fccd204277076155f10851dad72b76a49317"
	"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
	"github.com/prometheus/common c7de2306084e37d54b8be01f3541a8464345e9a5"
	"github.com/prometheus/procfs 418d78d0b9a7b7de3a6bbc8a23def624cc977bb2"
	"github.com/rcrowley/go-metrics e2704e165165ec55d062f5919b4b29494e9fa790"
	"github.com/samuel/go-zookeeper c4fab1ac1bec58281ad0667dc3f0907a9476ac47"
	"github.com/satori/go.uuid f58768cc1a7a7e77a3bd49e98cdd21419399b6a3"
	"github.com/shirou/gopsutil 8048a2e9c5773235122027dd585cf821b2af1249"
	"github.com/shirou/w32 bb4de0191aa41b5507caa14b0650cdbddcd9280b"
	"github.com/sirupsen/logrus a67f783a3814b8729bd2dac5780b5f78f8dbd64d"
	"github.com/soniah/gosnmp 35d70ef6436030897babd670877f2d4a1748c249"
	"github.com/streadway/amqp 70e15c650864f4fc47f5d3c82ea117285480895d"
	"github.com/stretchr/objx 477a77ecc69700c7cdeb1fa9e129548e1c1c393c"
	"github.com/stretchr/testify f35b8ab0b5a2cef36673838d662e249dd9c94686"
	"github.com/tidwall/gjson 1e3f6aeaa5bad08d777ea7807b279a07885dd8b2"
	"github.com/tidwall/match 1731857f09b1f38450e2c12409748407822dc6be"
	"github.com/vjeantet/grok ce01e59abcf6fbc9833b7deb5e4b8ee1769bcc53"
	"github.com/vmware/govmomi e3a01f9611c32b2362366434bcd671516e78955d"
	"github.com/wvanbergen/kafka e2edea948ddfee841ea9a263b32ccca15f7d6c2f"
	"github.com/wvanbergen/kazoo-go f72d8611297a7cf105da904c04198ad701a60101"
	"github.com/yuin/gopher-lua 799fa34954fbf844a6c25ea3b061bfd56f73bd10"
	"golang.org/x/crypto 5295e8364332db77d75fce11f1d19c053919a9c9 github.com/golang/crypto"
	"golang.org/x/net 4dfa2610cdf3b287375bbba5b8f2a14d3b01d8de github.com/golang/net"
	"golang.org/x/oauth2 d2e6202438beef2727060aa7cabdd924d92ebfd9 github.com/golang/oauth2"
	"golang.org/x/sys e4b3c5e9061176387e7cea65e4dc5853801f3fb7 github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
	"google.golang.org/appengine ae0ab99deb4dc413a2b4bd6c8bdd0eb67f1e4d06 github.com/golang/appengine"
	"google.golang.org/genproto c7e5094acea1ca1b899e2259d80a6b0f882f81f8 github.com/google/go-genproto"
	"google.golang.org/grpc 8dea3dc473e90c8179e519d91302d0597c0ca1d1 github.com/grpc/grpc-go"
	"gopkg.in/alecthomas/kingpin.v2 947dcec5ba9c011838740e680966fd7087a71d0d github.com/alecthomas/kingpin"
	"gopkg.in/asn1-ber.v1 379148ca0225df7a432012b8df0355c2a2063ac0 github.com/go-asn1-ber/asn1-ber"
	"gopkg.in/fatih/pool.v2 010e0b745d12eaf8426c95f9c3924d81dd0b668f github.com/fatih/pool"
	"gopkg.in/fsnotify.v1 c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9 github.com/fsnotify/fsnotify"
	"gopkg.in/gorethink/gorethink.v3 7f5bdfd858bb064d80559b2a32b86669c5de5d3b github.com/gorethink/gorethink"
	"gopkg.in/ldap.v2 bb7a9ca6e4fbc2129e3db588a34bc970ffe811a9 github.com/go-ldap/ldap"
	"gopkg.in/mgo.v2 9856a29383ce1c59f308dd1cf0363a79b5bef6b5 github.com/go-mgo/mgo"
	"gopkg.in/olivere/elastic.v5 fc3063a8c0686f64e94f4b2c17eb140c06eb6793 github.com/olivere/elastic"
	"gopkg.in/tomb.v1 dd632973f1e7218eb1089048e0798ec9ae7dceb8 github.com/go-tomb/tomb"
	"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml"
)

inherit golang-build golang-vcs-snapshot systemd user

GITHUB_BRANCH="release-1.8"
GITHUB_COMMIT="07d2f2d8"

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="systemd"

pkg_setup() {
	enewgroup telegraf
	enewuser telegraf -1 -1 -1 telegraf
}

src_compile() {
	pushd "src/${EGO_PN}" || die
	pwd
	find -iname telegraf.go
	date=`date -u --iso-8601=seconds`
	set -- env GOPATH="${S}" go build -i -v -work -x -ldflags="-X main.version=${PV} -X main.branch=${GITHUB_BRANCH} -X main.commit=${GITHUB_COMMIT} -X main.buildTime=${date}" -o telegraf \
		cmd/telegraf/telegraf.go
	echo "$@"
	"$@" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dosbin telegraf

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	insinto "/etc/${PN}"
	newins "etc/${PN}.conf" "${PN}.conf"
	keepdir "/etc/${PN}/${PN}.d"

	insinto "/etc/logrotate.d"
	doins "etc/logrotate.d/telegraf"

	keepdir "/var/log/${PN}"
	fowners telegraf:telegraf "/var/log/${PN}"

	dodoc -r CHANGELOG.md README.md docs/*

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
