# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A server-based agent to collect metrics from stacks, sensors, and systems."
HOMEPAGE="https://www.influxdata.com/time-series-platform/telegraf/"
SRC_URI="
	amd64? ( https://dl.influxdata.com/telegraf/releases/telegraf-${PV}_linux_amd64.tar.gz )
	x86? ( https://dl.influxdata.com/telegraf/releases/telegraf-${PV}_linux_i386.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

QA_PREBUILT="usr/sbin/telegraf"

DEPEND="acct-group/telegraf
	acct-user/telegraf"
RDEPEND=${DEPEND}"
	!net-analyzer/telegraf:0
	sys-libs/glibc
"

S="${WORKDIR}/telegraf-${PV}"

src_install() {
	dosbin usr/bin/telegraf

	newconfd "${FILESDIR}/telegraf.confd" "telegraf"
	newinitd "${FILESDIR}/telegraf.initd" "telegraf"

	if use systemd; then
		systemd_dounit "${FILESDIR}/telegraf.service"
	fi

	insinto /etc/telegraf
	doins etc/telegraf/telegraf.conf
	keepdir /etc/telegraf/telegraf.d

	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf

	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
