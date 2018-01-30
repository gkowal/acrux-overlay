# Copyright 2016-2017 Grzegorz Kowal <grzegorz@gkowal.info>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd

GITHUB_USER="influxdata"
GITHUB_REPO="telegraf"
GITHUB_TAG="${PV}"
GITHUB_BRANCH="release-1.5"
GITHUB_COMMIT="67440c95"
EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}"
GITHUB_PATH="${P}/src/${EGO_PN}"

DESCRIPTION="Agent for collecting metrics from the system."
HOMEPAGE="https://influxdata.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

DEPEND=">=dev-lang/go-1.6
	dev-vcs/git"

src_unpack() {
	unset http_proxy
	export GOPATH="${S}"
	go get -v ${EGO_PN}
	go get -v github.com/sparrc/gdm
	cd "${GITHUB_PATH}"
	git checkout -B production "tags/${GITHUB_TAG}"
	[ ${GITHUB_COMMIT} == `git rev-parse --short=8 HEAD` ] || die "Couldn't revert to commit ${GITHUB_COMMIT}"
	$GOPATH/bin/gdm restore
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
	dosbin "bin/telegraf"

	# Install the init and conf.d files.
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	# Install the Telegraf configuration file.
	insinto "/etc/${PN}"
	newins "src/github.com/${GITHUB_USER}/${GITHUB_REPO}/etc/${PN}.conf" "${PN}.conf"
	dodir "/etc/${PN}/${PN}.d"

	# Install the logrotate file.
	insinto "/etc/logrotate.d"
	newins "src/github.com/${GITHUB_USER}/${GITHUB_REPO}/etc/logrotate.d/${PN}" "${PN}"

	# Create the home and log directories.
	dodir "/var/log/${PN}"

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