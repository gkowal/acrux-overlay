# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Official ChatGPT Desktop application for Linux by OpenAI"
HOMEPAGE="https://developers.openai.com/codex/app"
SRC_URI="https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb -> ${P}.deb"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror"

# Prebuilt binaries bundled in official package
QA_PREBUILT="usr/lib/chatgpt/*"
QA_PRESTRIPPED="usr/lib/chatgpt/*"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libglvnd
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	virtual/zlib
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/tar"

src_unpack() {
	unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
	# Install application files
	mkdir -p "${D}/usr/lib/chatgpt" || die
	cp -r "${WORKDIR}/usr/lib/chatgpt/." "${D}/usr/lib/chatgpt/" || die "Failed to copy chatgpt files"

	# Install launchers and symlinks
	mkdir -p "${D}/usr/bin" || die
	dosym ../lib/chatgpt/codex-launcher /usr/bin/chatgpt
	dosym chatgpt /usr/bin/chatgpt-desktop
	dosym chatgpt /usr/bin/codex-desktop

	# Install AppArmor profile
	if [ -f "${WORKDIR}/etc/apparmor.d/chatgpt" ]; then
		mkdir -p "${D}/etc/apparmor.d" || die
		cp "${WORKDIR}/etc/apparmor.d/chatgpt" "${D}/etc/apparmor.d/" || die
	fi

	# Install desktop file
	if [ -f "${WORKDIR}/usr/share/applications/chatgpt.desktop" ]; then
		mkdir -p "${D}/usr/share/applications" || die
		cp "${WORKDIR}/usr/share/applications/chatgpt.desktop" "${D}/usr/share/applications/" || die
	fi

	# Install icon
	if [ -f "${WORKDIR}/usr/share/pixmaps/chatgpt.png" ]; then
		mkdir -p "${D}/usr/share/pixmaps" || die
		cp "${WORKDIR}/usr/share/pixmaps/chatgpt.png" "${D}/usr/share/pixmaps/" || die
		dosym chatgpt.png /usr/share/pixmaps/chatgpt-desktop.png
		dosym chatgpt.png /usr/share/pixmaps/codex-desktop.png
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if command -v update-desktop-database &>/dev/null; then
		update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
