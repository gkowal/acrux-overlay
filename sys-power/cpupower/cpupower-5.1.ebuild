# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# eutils: strip-linguas
inherit eutils systemd toolchain-funcs

DESCRIPTION="Shows and sets processor power related values"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="mirror://kernel/linux/kernel/v${PV%%.*}.x/linux-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE="cpufreq_bench debug nls systemd"

# File collision w/ headers of the deprecated cpufrequtils
RDEPEND="sys-apps/pciutils
	!<sys-apps/linux-misc-apps-3.6-r2
	!sys-power/cpufrequtils"
DEPEND="${RDEPEND}
	virtual/os-headers
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/linux-${PV}/tools/power/${PN}

src_compile() {
	myemakeargs=(
		DEBUG=$(usex debug true false)
		V=1
		CPUFREQ_BENCH=$(usex cpufreq_bench true false)
		NLS=$(usex nls true false)
		docdir=/usr/share/doc/${PF}/${PN}
		mandir=/usr/share/man
		libdir=/usr/$(get_libdir)
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		STRIP=true
		OPTIMIZATION=
		VERSION=${PV}
	)

	if [[ -n ${LINGUAS+set} ]]; then
		strip-linguas -i po
		myemakeargs+=( LANGUAGES="${LINGUAS}" )
	fi

	emake "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" "${myemakeargs[@]}" install
	dodoc README ToDo

	newconfd "${FILESDIR}"/conf.d cpupower
	newinitd "${FILESDIR}"/init.d cpupower

	if use systemd; then
		systemd_dounit "${FILESDIR}"/cpupower-frequency-set.service
		systemd_install_serviced "${FILESDIR}"/cpupower-frequency-set.service.conf
	fi
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
