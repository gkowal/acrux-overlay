# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/influxdata/telegraf"
SRC_URI="https://gkowal.info/gentoo/${CATEGORY}/${PN}/${P}.tar.xz"
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

GITHUB_COMMIT="3835522"
GITHUB_BRANCH="release-1.25"
GITHUB_VERSION="v${PV}"

src_compile() {
	unset LDFLAGS
	emake \
		COMMIT=${GITHUB_COMMIT} \
		BRANCH=${GITHUB_BRANCH} \
		VERSION=${GITHUB_VERSION} \
		telegraf
}

src_install() {
	dobin telegraf

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	if use systemd; then
		systemd_dounit scripts/telegraf.service
	fi

	keepdir /etc/telegraf/telegraf.d

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

	rm docs/developers/README.md
	dodoc -r CHANGELOG.md README.md docs/*

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
