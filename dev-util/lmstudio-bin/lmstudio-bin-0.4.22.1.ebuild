# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Discover, download, and run local LLMs"
HOMEPAGE="https://lmstudio.ai/"

# Map 0.4.22.1 to 0.4.22-1
MY_PV="${PV%.*}-${PV##*.}"

SRC_URI="https://installers.lmstudio.ai/linux/x64/${MY_PV}/LM-Studio-${MY_PV}-x64.deb"

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
	virtual/libcrypt:=
	vulkan? ( media-libs/vulkan-loader )
"
QA_PREBUILT="opt/lmstudio/*"

src_unpack() {
	unpack_deb "${A}"
}

src_install() {
	local backends="opt/LM-Studio/resources/app/.webpack/bin/extensions/backends"

	# Remove CUDA backend files if USE=cuda is disabled
	if ! use cuda; then
		rm -rf "${backends}/vendor/linux-llama-cuda-vendor-v1" || die
		rm -rf "${backends}"/llama.cpp-linux-x86_64-nvidia-cuda-avx2-* || die
	fi

	# Remove Vulkan backend files if USE=vulkan is disabled
	if ! use vulkan; then
		rm -rf opt/LM-Studio/resources/app/.webpack/bin/liblmstudio/vulkan || die
		rm -rf "${backends}/vendor/linux-llama-vulkan-vendor-v1" || die
		rm -rf "${backends}"/llama.cpp-linux-x86_64-vulkan-avx2-* || die
		rm -f opt/LM-Studio/libvulkan.so.1 || die
	fi

	# Install /opt/LM-Studio contents to /opt/lmstudio
	insinto /opt/lmstudio
	doins -r opt/LM-Studio/*

	# Restore execution permissions on all installed binaries
	local f
	while read -r f; do
		fperms +x "/opt/lmstudio/${f#opt/LM-Studio/}"
	done < <(find opt/LM-Studio -type f -executable)

	# Create symlink in /usr/bin
	dosym "../../../opt/lmstudio/lm-studio" "/usr/bin/lm-studio"

	# Install application icon dynamically
	local icon_file
	icon_file=$(find usr/share/icons opt/LM-Studio -name "*512*.png" 2>/dev/null | head -n 1)
	if [[ -f "${icon_file}" ]]; then
		doicon -s 512 "${icon_file}"
	fi

	# Adjust executable path and remove invalid category in desktop entry, then install it
	local desktop_file
	desktop_file=$(find usr/share/applications -name "*.desktop" 2>/dev/null | head -n 1)
	if [[ -f "${desktop_file}" ]]; then
		sed -i 's|Exec=/opt/LM-Studio/lm-studio|Exec=lm-studio|g' "${desktop_file}" || die
		sed -i 's|Exec=AppRun|Exec=lm-studio|g' "${desktop_file}" || die
		sed -i '/^category=/d' "${desktop_file}" || die
		domenu "${desktop_file}"
	fi
}
