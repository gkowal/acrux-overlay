# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://gkowal.info/gentoo/${CATEGORY}/${PN}/${P}.tar.gz"
SRC_URI+=" https://gkowal.info/gentoo/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="systemd"

RESTRICT="strip"

BDEPEND="dev-lang/go"
DEPEND="acct-group/telegraf
	acct-user/telegraf"
RDEPEND="${DEPEND}"

src_compile() {
	DATE=`date -u --iso-8601=seconds`
	set -- env GO111MODULE=on go build -v -x -o bin/telegraf \
		-ldflags="-X main.version=${PV} -X main.branch=${GITHUB_BRANCH} -X main.commit=${GITHUB_COMMIT} -X main.buildTime=${DATE}" \
		./cmd/telegraf
	echo "$@"
	"$@" || die
}

src_install() {
	dosbin bin/telegraf

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi

	insinto /etc/telegraf
	doins etc/telegraf.conf
	keepdir /etc/telegraf/telegraf.d

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

	dodoc -r CHANGELOG.md README.md docs/*

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
