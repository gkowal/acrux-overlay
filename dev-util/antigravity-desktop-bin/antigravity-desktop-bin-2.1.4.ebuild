# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Google Antigravity Desktop Client (binary version)"
HOMEPAGE="https://antigravity.google"
BUILD_ID="6481382726303744"
SRC_URI="https://storage.googleapis.com/antigravity-public/antigravity-hub/${PV}-${BUILD_ID}/linux-x64/Antigravity.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Antigravity-x64"

LICENSE="Google-Antigravity"
SLOT="0"
KEYWORDS="~amd64"

# Standard Electron application runtime dependencies
RDEPEND="
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
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

src_install() {
	# Copy all application files to /opt
	insinto "/opt/${PN}"
	doins -r *

	# Restore execution permissions for all files that were executable in the source tree
	while read -r f; do
		f="${f#./}"
		fperms +x "/opt/${PN}/${f}"
	done < <(find . -type f -executable)

	# Create launch wrapper symlink
	dosym -r "/opt/${PN}/antigravity" "/usr/bin/antigravity"

	# Install Desktop Entry
	make_desktop_entry "antigravity" "Antigravity" "antigravity" "Development;Utility;"
}
