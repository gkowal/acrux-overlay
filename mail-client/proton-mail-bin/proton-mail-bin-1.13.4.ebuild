# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Official desktop application for Proton Mail and Proton Calendar"
HOMEPAGE="https://proton.me/mail"
SRC_URI="https://proton.me/download/mail/linux/${PV}/ProtonMail-desktop-beta.deb -> ${P}.deb"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

QA_PREBUILT="usr/lib/proton-mail/*"
QA_PRESTRIPPED="usr/lib/proton-mail/*"
QA_FLAGS_IGNORED="usr/lib/proton-mail/.*"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	virtual/zlib
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/tar"

src_unpack() {
	unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
	dostrip -x /usr/lib/proton-mail

	# Install binary payload into /usr/lib/proton-mail
	mkdir -p "${ED}/usr/lib/proton-mail" || die
	cp -a "${WORKDIR}/usr/lib/proton-mail/." "${ED}/usr/lib/proton-mail/" || die "Failed to copy proton-mail files"

	# Launcher symlink
	mkdir -p "${ED}/usr/bin" || die
	dosym ../lib/proton-mail/"Proton Mail Beta" /usr/bin/proton-mail

	# Desktop entry
	if [[ -f "${WORKDIR}/usr/share/applications/proton-mail.desktop" ]]; then
		mkdir -p "${ED}/usr/share/applications" || die
		cp "${WORKDIR}/usr/share/applications/proton-mail.desktop" "${ED}/usr/share/applications/" || die
	fi

	# Pixmap icon
	if [[ -f "${WORKDIR}/usr/share/pixmaps/proton-mail.png" ]]; then
		mkdir -p "${ED}/usr/share/pixmaps" || die
		cp "${WORKDIR}/usr/share/pixmaps/proton-mail.png" "${ED}/usr/share/pixmaps/" || die
	fi

	# Mask revdep-rebuild scan on bundled binaries
	mkdir -p "${ED}/etc/revdep-rebuild" || die
	cat > "${ED}/etc/revdep-rebuild/99${PN}" <<-EOF || die
		SEARCH_DIRS_MASK="/usr/lib/proton-mail"
	EOF
}
