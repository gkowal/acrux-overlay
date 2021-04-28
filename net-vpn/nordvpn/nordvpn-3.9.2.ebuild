# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 systemd unpacker

DESCRIPTION="NordVPN client"
HOMEPAGE="https://nordvpn.com/"
SRC_URI="https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/${PN}_${PV}-1_amd64.deb"

LICENSE="NordVPN-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="systemd"

RDEPEND="
	dev-libs/libxml2
"

QA_PREBUILT="
	usr/bin/nordvpn
	usr/sbin/nordvpnd
	var/lib/nordvpn/openvpn
"

S="${WORKDIR}"

src_install() {
	dobin usr/bin/nordvpn
	dosbin usr/sbin/nordvpnd
	newinitd etc/init.d/"${PN}" "${PN}"
	if use systemd; then
		systemd_dounit usr/lib/systemd/system/"nordvpnd.service"
		systemd_dounit usr/lib/systemd/system/"nordvpnd.socket"
	fi
	insinto /usr/lib/tmpfiles.d
	doins usr/lib/tmpfiles.d/"${PN}.conf"
	gunzip usr/share/man/man1/"${PN}.1.gz"
	insinto /usr/share/man/man1
	doins usr/share/man/man1/"${PN}.1"
	newbashcomp usr/share/bash-completion/completions/nordvpn nordvpn
	keepdir /var/lib/"${PN}"
	insinto /var/lib/"${PN}"
	doins var/lib/nordvpn/{icon.svg,openvpn}
	insinto /var/lib/"${PN}"/data
	doins var/lib/nordvpn/data/*
	fperms +x /var/lib/nordvpn/openvpn
}
