# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Official Claude AI desktop application by Anthropic"
HOMEPAGE="https://claude.ai"
SRC_URI="https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${PV}_amd64.deb -> ${P}.deb"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
IUSE="+wayland"
RESTRICT="bindist mirror strip"

QA_PREBUILT="opt/claude-desktop/*"
QA_PRESTRIPPED="opt/claude-desktop/*"
QA_FLAGS_IGNORED="opt/claude-desktop/.*"

RDEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libglvnd
	media-libs/mesa[gbm(+)]
	media-video/pipewire
	net-misc/socat
	net-print/cups
	sys-apps/bubblewrap
	sys-apps/dbus
	sys-apps/util-linux
	sys-apps/xdg-desktop-portal
	sys-libs/libcap-ng
	sys-libs/libseccomp
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/tar"

src_unpack() {
	unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
	dostrip -x /opt/claude-desktop

	# Install main application files
	mkdir -p "${ED}/opt/claude-desktop" || die
	cp -a "${WORKDIR}/usr/lib/claude-desktop/." "${ED}/opt/claude-desktop/" || die "Failed to copy files"

	# Fix chrome-sandbox setuid permissions
	if [[ -f "${ED}/opt/claude-desktop/chrome-sandbox" ]]; then
		fperms 4755 /opt/claude-desktop/chrome-sandbox
	fi

	# Generate Wayland / configuration aware launcher
	local wayland_flags=""
	if use wayland; then
		wayland_flags='
if [[ -n "${WAYLAND_DISPLAY:-}" || "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
	platform=(--ozone-platform=wayland --enable-features=WaylandWindowDecorations)
	for f in "${flags[@]}" "$@"; do
		case "$f" in
			--ozone-platform=*|--ozone-platform-hint=*) platform=() ;;
		esac
	done
fi'
	fi

	cat > "${ED}/opt/claude-desktop/claude-launcher" <<- EOF || die
#!/bin/bash
set -euo pipefail

flags=()
conf="\${XDG_CONFIG_HOME:-\${HOME:-}/.config}/claude-desktop-flags.conf"
if [[ -r "\$conf" ]]; then
	while IFS= read -r line || [[ -n "\$line" ]]; do
		line="\${line%%#*}"
		[[ -n "\${line//[[:space:]]/}" ]] || continue
		read -r -a words <<<"\$line"
		flags+=("\${words[@]}")
	done <"\$conf"
fi

platform=()
${wayland_flags}

exec /opt/claude-desktop/claude-desktop "\${platform[@]}" "\${flags[@]}" "\$@"
EOF
	fperms +x /opt/claude-desktop/claude-launcher

	# Install CLI symlinks
	mkdir -p "${ED}/usr/bin" || die
	dosym ../../opt/claude-desktop/claude-launcher /usr/bin/claude-desktop
	dosym claude-desktop /usr/bin/claude

	# Cowork compatibility: provide virtiofsd in /usr/libexec where app.asar searches
	if [[ -x "${ED}/opt/claude-desktop/resources/virtiofsd" ]]; then
		mkdir -p "${ED}/usr/libexec" || die
		dosym ../../opt/claude-desktop/resources/virtiofsd /usr/libexec/virtiofsd
	fi

	# Install desktop entry
	if [[ -f "${WORKDIR}/usr/share/applications/com.anthropic.Claude.desktop" ]]; then
		domenu "${WORKDIR}/usr/share/applications/com.anthropic.Claude.desktop"
	fi

	# Install application icons
	if [[ -d "${WORKDIR}/usr/share/icons" ]]; then
		mkdir -p "${ED}/usr/share/icons" || die
		cp -a "${WORKDIR}/usr/share/icons/." "${ED}/usr/share/icons/" || die
	fi

	# Mask prebuilt binaries from revdep-rebuild scans
	mkdir -p "${ED}/etc/revdep-rebuild" || die
	cat > "${ED}/etc/revdep-rebuild/99claude-desktop-bin" <<-'EOF'
SEARCH_DIRS_MASK="/opt/claude-desktop"
EOF
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
