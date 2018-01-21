# Copyright 2016-2017 Grzegorz Kowal <grzegorz@gkowal.info>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user systemd

GITHUB_USER="influxdata"
GITHUB_REPO="influxdb"
GITHUB_BRANCH="1.4"
GITHUB_TAG="v${PV}"
GITHUB_COMMIT="6d2685d1"
EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}"
GITHUB_PATH="${P}/src/${EGO_PN}"

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics."
HOMEPAGE="https://influxdata.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

DEPEND=">=dev-lang/go-1.7
	dev-vcs/git"

pkg_setup() {
	enewgroup influxdb
	enewuser  influxdb -1 -1 /var/lib/influxdb influxdb
}

src_unpack() {
	unset http_proxy
	export GOPATH="${S}"
	go get -v ${EGO_PN}
	go get -v github.com/sparrc/gdm
	cd "${GITHUB_PATH}"
	git checkout -B production "tags/${GITHUB_TAG}"
	[ ${GITHUB_COMMIT} == `git rev-parse --short=8 HEAD` ] || die "Couldn't revert to commit ${GITHUB_COMMIT}"
	$GOPATH/bin/gdm restore
	cd ${S}
	go get -v ${EGO_PN}
}

src_compile() {
	export GOPATH="${S}"
	cd "${WORKDIR}/${GITHUB_PATH}"
	go clean ./...
	date=`date -u --iso-8601=seconds`
	go install -ldflags="-X main.version=${PV} -X main.branch=${GITHUB_BRANCH} -X main.commit=${GITHUB_COMMIT} -X main.buildTime=${date}" ./...
}

src_install() {
	# Copy compiled binaries over to image directory.
	dobin "bin/influx"
	dobin "bin/influx_inspect"
	dobin "bin/influx_stress"
	dobin "bin/influx_tsm"
	dosbin "bin/influxd"

	# Install the init and conf.d files.
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	# Install the logrotate file.
	insinto "/etc/logrotate.d"
	newins "src/github.com/${GITHUB_USER}/${GITHUB_REPO}/scripts/logrotate" "${PN}"

	# Install the InfluxDB configuration file.
	insinto "/etc/${PN}"
	newins "src/github.com/${GITHUB_USER}/${GITHUB_REPO}/etc/config.sample.toml" "${PN}.conf"

	# Create the home and log directories.
	keepdir "/var/lib/${PN}"
	dodir "/var/log/${PN}"

	# Fix the permissions.
	fowners root:influxdb "/usr/bin/influx"
	fperms u=rwx,g=rx,o= "/usr/bin/influx"
	fowners root:influxdb "/usr/bin/influx_inspect"
	fperms u=rwx,g=rx,o= "/usr/bin/influx_inspect"
	fowners root:influxdb "/usr/bin/influx_stress"
	fperms u=rwx,g=rx,o= "/usr/bin/influx_stress"
	fowners root:influxdb "/usr/bin/influx_tsm"
	fperms u=rwx,g=rx,o= "/usr/bin/influx_tsm"
	fowners root:influxdb "/usr/sbin/influxd"
	fperms u=rwx,g=rx,o= "/usr/sbin/influxd"
	fowners root:influxdb "/etc/${PN}"
	fperms u=rwx,g=rx,o= "/etc/${PN}"
	fowners root:influxdb "/etc/${PN}/${PN}.conf"
	fperms u=rw,g=r,o= "/etc/${PN}/${PN}.conf"
	fowners influxdb:influxdb "/var/lib/${PN}"
	fperms u=rwx,g=rx,o= "/var/lib/${PN}"
	fowners influxdb:influxdb "/var/log/${PN}"
	fperms u=rwx,g=rx,o= "/var/log/${PN}"

	# Install the systemd unit file.
	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
