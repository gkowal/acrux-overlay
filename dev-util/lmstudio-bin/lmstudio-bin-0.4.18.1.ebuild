# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Discover, download, and run local LLMs"
HOMEPAGE="https://lmstudio.ai/"

# Map 0.4.18.1 to 0.4.18-1
MY_PV="${PV%.*}-${PV##*.}"

SRC_URI="https://installers.lmstudio.ai/linux/x64/${MY_PV}/LM-Studio-${MY_PV}-x64.AppImage"

S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
IUSE="cuda vulkan rocm"

RESTRICT="bindist mirror"

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/nss
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/libXtst
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	virtual/zlib
	x11-libs/pango
	dev-libs/glib:2
	media-libs/fontconfig
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	dev-libs/expat
	x11-libs/libxcb
	x11-libs/libxkbcommon
	virtual/udev
	vulkan? ( media-libs/vulkan-loader )
"
QA_PREBUILT="opt/lmstudio/*"

src_unpack() {
	# Copy AppImage to WORKDIR and make it executable to extract it
	cp "${DISTDIR}/LM-Studio-${MY_PV}-x64.AppImage" "${WORKDIR}/lmstudio.AppImage" || die
	chmod +x "${WORKDIR}/lmstudio.AppImage" || die
	"${WORKDIR}/lmstudio.AppImage" --appimage-extract > /dev/null || die "Failed to extract AppImage"
}

src_install() {
	local backends="squashfs-root/resources/app/.webpack/bin/extensions/backends"

	# Remove CUDA backend files if USE=cuda is disabled
	if ! use cuda; then
		rm -rf "${backends}/vendor/linux-llama-cuda-vendor-v1" || die
		rm -rf "${backends}"/llama.cpp-linux-x86_64-nvidia-cuda-avx2-* || die
	fi

	# Remove Vulkan backend files if USE=vulkan is disabled
	if ! use vulkan; then
		rm -rf squashfs-root/resources/app/.webpack/bin/liblmstudio/vulkan || die
		rm -rf "${backends}/vendor/linux-llama-vulkan-vendor-v1" || die
		rm -rf "${backends}"/llama.cpp-linux-x86_64-vulkan-avx2-* || die
		rm -f squashfs-root/libvulkan.so.1 || die
	fi

	# Install the remaining extracted AppImage files to /opt/lmstudio
	insinto /opt/lmstudio
	doins -r squashfs-root/*

	# Fix executable permissions on binaries
	fperms +x /opt/lmstudio/AppRun
	fperms +x /opt/lmstudio/lm-studio
	fperms +x /opt/lmstudio/chrome_crashpad_handler
	fperms +x /opt/lmstudio/chrome-sandbox

	# Create symlink in /usr/bin
	dosym "../../../opt/lmstudio/lm-studio" "/usr/bin/lm-studio"

	# Install application icon
	doicon -s 512 squashfs-root/usr/share/icons/hicolor/0x0/apps/lm-studio.png

	# Adjust executable path and remove invalid category in desktop entry, then install it
	sed -i 's|Exec=AppRun|Exec=lm-studio|g' squashfs-root/lm-studio.desktop || die
	sed -i '/^category=/d' squashfs-root/lm-studio.desktop || die
	domenu squashfs-root/lm-studio.desktop
}
