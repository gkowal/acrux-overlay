# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Official desktop application for Proton Pass password manager"
HOMEPAGE="https://proton.me/pass"
SRC_URI="https://proton.me/download/pass/linux/proton-pass_${PV}_amd64.deb -> ${P}.deb"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip"

QA_PREBUILT="usr/lib/proton-pass/*"
QA_PRESTRIPPED="usr/lib/proton-pass/*"
QA_FLAGS_IGNORED="usr/lib/proton-pass/.*"

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
	dostrip -x /usr/lib/proton-pass

	# Install binary payload into /usr/lib/proton-pass
	mkdir -p "${ED}/usr/lib/proton-pass" || die
	cp -a "${WORKDIR}/usr/lib/proton-pass/." "${ED}/usr/lib/proton-pass/" || die "Failed to copy proton-pass files"

	# Launcher symlink
	mkdir -p "${ED}/usr/bin" || die
	dosym ../lib/proton-pass/"Proton Pass" /usr/bin/proton-pass

	# Desktop entry
	if [[ -f "${WORKDIR}/usr/share/applications/proton-pass.desktop" ]]; then
		mkdir -p "${ED}/usr/share/applications" || die
		cp "${WORKDIR}/usr/share/applications/proton-pass.desktop" "${ED}/usr/share/applications/" || die
	fi

	# Pixmap icon
	if [[ -f "${WORKDIR}/usr/share/pixmaps/proton-pass.png" ]]; then
		mkdir -p "${ED}/usr/share/pixmaps" || die
		cp "${WORKDIR}/usr/share/pixmaps/proton-pass.png" "${ED}/usr/share/pixmaps/" || die
	fi

	# Mask revdep-rebuild scan on bundled binaries
	mkdir -p "${ED}/etc/revdep-rebuild" || die
	cat > "${ED}/etc/revdep-rebuild/99${PN}" <<-EOF || die
		SEARCH_DIRS_MASK="/usr/lib/proton-pass"
	EOF
}
