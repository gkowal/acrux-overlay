# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Open source AI coding desktop application (binary version)"
HOMEPAGE="https://opencode.ai"
SRC_URI="https://github.com/anomalyco/opencode/releases/download/v${PV}/opencode-desktop-linux-amd64.deb -> ${P}.deb"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
"

BDEPEND="app-arch/tar"

src_install() {
	# Copy application files to /opt/OpenCode
	insinto /opt/OpenCode
	doins -r opt/OpenCode/*

	# Restore execution permissions for main executable and binary libraries
	local exec_files=(
		"ai.opencode.desktop"
		"chrome-sandbox"
		"chrome_crashpad_handler"
		"libEGL.so"
		"libffmpeg.so"
		"libGLESv2.so"
		"libvk_swiftshader.so"
		"libvulkan.so.1"
	)
	local f
	for f in "${exec_files[@]}"; do
		if [[ -f "${ED}/opt/OpenCode/${f}" ]]; then
			fperms +x "/opt/OpenCode/${f}"
		fi
	done

	# Set sandbox permissions if chrome-sandbox exists
	if [[ -f "${ED}/opt/OpenCode/chrome-sandbox" ]]; then
		fperms 4755 "/opt/OpenCode/chrome-sandbox"
	fi

	# Create launch wrapper symlink
	dosym -r "/opt/OpenCode/ai.opencode.desktop" "/usr/bin/opencode-desktop"

	# Install desktop icons
	if [[ -d usr/share/icons ]]; then
		insinto /usr/share/icons
		doins -r usr/share/icons/*
	fi

	# Install desktop entries
	if [[ -d usr/share/applications ]]; then
		domenu usr/share/applications/*.desktop
	else
		make_desktop_entry "opencode-desktop" "OpenCode" "ai.opencode.desktop" "Development;"
	fi
}
