# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd xdg-utils

#go-module_set_globals

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="selinux tools"

RDEPEND="acct-group/syncthing
	acct-user/syncthing
	tools? ( acct-group/stdiscosrv
		acct-group/strelaysrv
		acct-user/stdiscosrv
		acct-user/strelaysrv )
	selinux? ( sec-policy/selinux-syncthing )"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
		|| die

	# As of 1.3.2, stupgrades still fails to compile. This command was not present
	# in releases older than 1.3.0, is not compiled in by default (USE=tools
	# must be set) an in any case we do not really need this, therefore just
	# get rid of the offending code until upstream has fixed it.
	rm -rf cmd/stupgrades
}

src_compile() {
	go run build.go -version "v${PV}" -no-upgrade install \
		$(usex tools "all" "") || die "build failed"
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
	doman man/*.[157]
	einstalldocs

	dobin bin/syncthing
	if use tools ; then
		exeinto /usr/libexec/syncthing
		local exe
		for exe in bin/* ; do
			[[ "${exe}" == "bin/syncthing" ]] || doexe "${exe}"
		done
	fi

	# openrc and systemd service files
	systemd_dounit etc/linux-systemd/system/${PN}{@,-resume}.service
	systemd_douserunit etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use tools ; then
		# openrc and systemd service files

		systemd_dounit "${FILESDIR}/stdiscosrv.service"
		newconfd "${FILESDIR}/stdiscosrv.confd" stdiscosrv
		newinitd "${FILESDIR}/stdiscosrv.initd" stdiscosrv

		systemd_dounit cmd/strelaysrv/etc/linux-systemd/strelaysrv.service
		newconfd "${FILESDIR}/strelaysrv.confd" strelaysrv
		newinitd "${FILESDIR}/strelaysrv.initd" strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}/stdiscosrv.logrotate" strelaysrv
		newins "${FILESDIR}/strelaysrv.logrotate" strelaysrv
	fi
}
