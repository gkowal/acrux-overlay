# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Dragonfly Mail Agent (dma) - a lightweight Mail Transport Agent"
HOMEPAGE="https://github.com/corecode/dma"
SRC_URI="https://github.com/corecode/dma/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

IUSE="+mta"

# build programs
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

# build libraries and headers
DEPEND="
	dev-libs/openssl
"

# runtime
RDEPEND="
	${DEPEND}
	acct-user/mail
	acct-group/mail
	mta? (
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/netqmail
		!mail-mta/notqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/sendmail
		!mail-mta/opensmtpd[mta]
		!mail-mta/ssmtp[mta]
		!mail-mta/msmtp[mta]
	)
"

src_compile() {
	tc-export CC
	emake
}

src_install() {
	exeopts -m 2755 -o root -g mail
	exeinto /usr/sbin
	doexe dma
	exeopts -m 4754 -o root -g mail
	exeinto /usr/libexec
	doexe dma-mbox-create

	diropts -m 2755 -o root -g mail
	keepdir /var/spool/dma
	keepdir /var/mail

	insinto /etc/dma
	insopts -m 644 -o root -g mail
	doins dma.conf
	insopts -m 640 -o root -g mail
	doins auth.conf

	insinto /etc/cron.d
	insopts -m 644
	newins "${FILESDIR}"/dma.cron dma

	systemd_dounit "${FILESDIR}"/dma-flush.service
	systemd_dounit "${FILESDIR}"/dma-flush.timer

	doman dma.8

	if use mta; then
		dosym dma /usr/sbin/sendmail
		dosym dma /usr/sbin/mailq
	fi
}
