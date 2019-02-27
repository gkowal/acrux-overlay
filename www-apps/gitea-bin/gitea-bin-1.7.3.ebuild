# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user systemd

MY_PN=${PN/-bin/}
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="Gitea is a community managed lightweight code hosting solution written in Go"
HOMEPAGE="http://gitea.io"
SRC_URI="https://dl.gitea.io/gitea/${PV}/${MY_PN}-${PV}-linux-amd64"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="systemd"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup gitea
	enewuser gitea -1 /bin/bash /var/lib/gitea gitea
}

src_unpack() {
	mkdir "${WORKDIR}/${MY_PN}-${PV}"
}

src_install() {
	keepdir /etc/gitea

	newsbin "${DISTDIR}"/${MY_PN}-${PV}-linux-amd64 gitea

	newconfd "${FILESDIR}"/gitea.confd gitea
	newinitd "${FILESDIR}"/gitea.initd gitea
	if use systemd; then
		systemd_newunit "${FILESDIR}"/gitea.service gitea.service
	fi

	keepdir /var/{lib,log}/gitea
	fowners gitea:gitea /var/{lib,log}/gitea
	fperms 0750 /var/{lib,log}/gitea
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
