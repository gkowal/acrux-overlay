# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="ChatGPT Desktop for Linux - Community package built from macOS DMG"
HOMEPAGE="https://github.com/ilysenko/codex-desktop-linux"
COMMIT="042adb7b23b1f47ca8d6a09da0b1abc5e00ff4a7"

# Note: net-libs/nodejs is not available for x32 profile (x86_64 only)
NODE_RUNTIME_VERSION="v22.22.2"
NODE_RUNTIME_ARCH="linux-x64"
NODE_RUNTIME_SHA256="88fd1ce767091fd8d4a99fdb2356e98c819f93f3b1f8663853a2dee9b438068a"

SRC_URI="https://github.com/ilysenko/codex-desktop-linux/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://persistent.oaistatic.com/codex-app-prod/ChatGPT.dmg
		-> ${P}-upstream.dmg
	https://nodejs.org/dist/${NODE_RUNTIME_VERSION}/node-${NODE_RUNTIME_VERSION}-${NODE_RUNTIME_ARCH}.tar.xz
		-> ${P}-node-runtime.tar.xz"

S="${WORKDIR}/codex-desktop-linux-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror"

# Prebuilt binaries bundled in application and npm package prebuilds
QA_PREBUILT="opt/chatgpt-desktop/* opt/codex-desktop/*"
QA_PRESTRIPPED="opt/chatgpt-desktop/* opt/codex-desktop/*"

# Build dependencies
DEPEND="
	|| ( dev-lang/rust dev-lang/rust-bin )
	sys-apps/util-linux
	sys-auth/polkit
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
	net-misc/curl
	app-arch/7zip
	app-arch/unzip
	dev-build/make
	sys-devel/gcc
"
RDEPEND="${DEPEND}
	app-accessibility/at-spi2-core
	media-libs/alsa-lib
	x11-libs/libnotify
	x11-misc/xdg-utils
"
BDEPEND="
	virtual/pkgconfig
	dev-build/ninja
	app-arch/tar
"

# Upstream DMG URL and SHA256 (will be updated with new versions)
UPSTREAM_DMG_URL="https://persistent.oaistatic.com/codex-app-prod/ChatGPT.dmg"
UPSTREAM_DMG_SHA256="7b3722e4f5864202b1dd69e6e6062f2f8c4388d215091503c73e1957b4cbf97a"

src_prepare() {
	# Remove any cached DMG from previous builds
	rm -f "${S}/Codex.dmg" "${S}/ChatGPT.dmg" || true

	# Make scripts executable
	chmod +x scripts/*.sh scripts/lib/*.sh launcher/*.sh 2>/dev/null || true

	# Apply any necessary patches
	default
}

src_compile() {
	# The actual compilation is done in src_install via install.sh
	# This is a hybrid approach as the build involves downloading binaries
	true
}

src_install() {
	local WORK_DIR
	WORK_DIR="$(mktemp -d)"
	local NODE_DIR
	NODE_DIR="${WORK_DIR}/node-runtime"

	# Extract and verify the managed Node.js runtime
	mkdir -p "${NODE_DIR}"
	tar -xJf "${DISTDIR}/${P}-node-runtime.tar.xz" -C "${NODE_DIR}" || \
		die "Failed to extract Node.js runtime"
	# Verify SHA256
	printf '%s  %s\n' "${NODE_RUNTIME_SHA256}" \
		"${DISTDIR}/${P}-node-runtime.tar.xz" | sha256sum -c - || \
		die "Node.js runtime checksum mismatch"

	# Copy the upstream DMG from Portage distfiles
	cp "${DISTDIR}/${P}-upstream.dmg" "${S}/ChatGPT.dmg" || \
		die "Failed to copy upstream DMG"
	cp "${DISTDIR}/${P}-upstream.dmg" "${S}/Codex.dmg" || true

	# Set environment variables for the build
	export CODEX_INSTALL_DIR="${WORK_DIR}/codex-app"
	export CODEX_INSTALL_ROOT="${WORK_DIR}"
	export SEVEN_ZIP_CMD="7zz"
	export CODEX_MANAGED_NODE_SOURCE="${NODE_DIR}/node-${NODE_RUNTIME_VERSION}-${NODE_RUNTIME_ARCH}"
	export CODEX_UPSTREAM_DMG_URL="${UPSTREAM_DMG_URL}"

	# Run the installer to build the application
	bash "${S}/install.sh" "${S}/ChatGPT.dmg" || die "install.sh failed"

	# Install the main application to /opt/chatgpt-desktop
	mkdir -p "${D}/opt/chatgpt-desktop" || die
	cp -r "${WORK_DIR}/codex-app/." "${D}/opt/chatgpt-desktop/" || \
		die "Failed to copy codex-app"
	dosym chatgpt-desktop /opt/codex-desktop

	# Create the launcher script at /usr/bin/chatgpt-desktop and symlink codex-desktop
	cat > "${T}/chatgpt-desktop" << 'EOF'
#!/bin/bash
set -euo pipefail

exec /opt/chatgpt-desktop/start.sh "$@"
EOF
	mkdir -p "${D}/usr/bin" || die
	cp "${T}/chatgpt-desktop" "${D}/usr/bin/chatgpt-desktop" || die
	chmod 755 "${D}/usr/bin/chatgpt-desktop" || die
	dosym chatgpt-desktop /usr/bin/codex-desktop

	# Install the update manager if built
	if [ -f "${WORK_DIR}/codex-app/update-builder/target/release/codex-update-manager" ]; then
		mkdir -p "${D}/usr/bin" || die
		cp "${WORK_DIR}/codex-app/update-builder/target/release/codex-update-manager" \
			"${D}/usr/bin/codex-update-manager" || die
		chmod 755 "${D}/usr/bin/codex-update-manager" || die
		dosym codex-update-manager /usr/bin/chatgpt-update-manager
	fi

	# Install systemd user service
	if [ -f "${S}/packaging/linux/codex-update-manager.service" ]; then
		mkdir -p "${D}/usr/lib/systemd/user" || die
		cp "${S}/packaging/linux/codex-update-manager.service" \
			"${D}/usr/lib/systemd/user/" || die
	fi

	# Install desktop entry
	if [ -f "${S}/packaging/linux/codex-desktop.desktop" ]; then
		mkdir -p "${D}/usr/share/applications" || die
		cp "${S}/packaging/linux/codex-desktop.desktop" \
			"${D}/usr/share/applications/" || die
	fi

	# Install icons
	if [ -f "${S}/assets/codex.png" ]; then
		mkdir -p "${D}/usr/share/pixmaps" || die
		cp "${S}/assets/codex.png" "${D}/usr/share/pixmaps/codex-desktop.png" || die
		dosym codex-desktop.png /usr/share/pixmaps/chatgpt-desktop.png
	fi

	# Install Polkit policy
	if [ -f "${S}/packaging/linux/com.github.ilysenko.codex-desktop-linux.update.policy" ]; then
		mkdir -p "${D}/usr/share/polkit-1/actions" || die
		cp "${S}/packaging/linux/com.github.ilysenko.codex-desktop-linux.update.policy" \
			"${D}/usr/share/polkit-1/actions/" || die
	fi

	# Install the desktop entry doctor script
	if [ -f "${WORK_DIR}/codex-app/.codex-linux/codex-desktop-entry-doctor.sh" ]; then
		mkdir -p "${D}/usr/bin" || die
		cp "${WORK_DIR}/codex-app/.codex-linux/codex-desktop-entry-doctor.sh" \
			"${D}/usr/bin/codex-desktop-entry-doctor" || die
		chmod 755 "${D}/usr/bin/codex-desktop-entry-doctor" || die
	fi

	# Clean up
	rm -rf "${WORK_DIR}"
}

pkg_postinst() {
	xdg_pkg_postinst

	# Update desktop database
	if command -v update-desktop-database &>/dev/null; then
		update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
	fi

	# Try to start the update manager service if systemd is available
	if command -v systemctl &>/dev/null; then
		systemctl --user daemon-reload 2>/dev/null || true
		systemctl --user enable --now codex-update-manager.service 2>/dev/null || true
	fi
}

pkg_postrm() {
	xdg_pkg_postrm

	# Clean up update manager service
	if command -v systemctl &>/dev/null; then
		systemctl --user disable --now codex-update-manager.service 2>/dev/null || true
		systemctl --user daemon-reload 2>/dev/null || true
	fi
}
