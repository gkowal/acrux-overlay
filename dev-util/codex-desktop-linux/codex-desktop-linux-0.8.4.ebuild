# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild builds Codex Desktop for Linux from source
# It fetches the upstream macOS DMG and applies Linux compatibility patches

inherit desktop systemd xdg

DESCRIPTION="Codex Desktop for Linux - Community-built Linux package from macOS DMG"
HOMEPAGE="https://github.com/ilysenko/codex-desktop-linux"
COMMIT="c868dcd19f3a176d833ac9f1d35873f6a21e8921"

# Note: net-libs/nodejs is not available for x32 profile (x86_64 only)
NODE_RUNTIME_VERSION="v22.22.2"
NODE_RUNTIME_ARCH="linux-x64"
NODE_RUNTIME_SHA256="88fd1ce767091fd8d4a99fdb2356e98c819f93f3b1f8663853a2dee9b438068a"

SRC_URI="https://github.com/ilysenko/codex-desktop-linux/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://persistent.oaistatic.com/codex-app-prod/Codex.dmg
		-> ${P}-upstream.dmg
	https://nodejs.org/dist/${NODE_RUNTIME_VERSION}/node-${NODE_RUNTIME_VERSION}-${NODE_RUNTIME_ARCH}.tar.xz
		-> ${P}-node-runtime.tar.xz"

S="${WORKDIR}/codex-desktop-linux-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

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
UPSTREAM_DMG_URL="https://persistent.oaistatic.com/codex-app-prod/Codex.dmg"
UPSTREAM_DMG_SHA256="e0d07909bd047d897db544e366103d4f14c06c1e038e8443aa97dc90405fcacf"

src_prepare() {
	# Remove any cached DMG from previous builds
	rm -f "${S}/Codex.dmg" || true

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

	# Set environment variables for the build
	export CODEX_INSTALL_DIR="${WORK_DIR}/codex-app"
	export CODEX_INSTALL_ROOT="${WORK_DIR}"
	export SEVEN_ZIP_CMD="7zz"
	export CODEX_MANAGED_NODE_SOURCE="${NODE_DIR}/node-${NODE_RUNTIME_VERSION}-${NODE_RUNTIME_ARCH}"

	# Run the installer to build the application
	bash "${S}/install.sh" || die "install.sh failed"

	# Install the main application to /opt/codex-desktop
	dodir /opt/codex-desktop
	cp -r "${WORK_DIR}/codex-app/." "${D}/opt/codex-desktop/" || \
		die "Failed to copy codex-app"

	# Create the launcher script at /usr/bin/codex-desktop
	cat > "${D}/usr/bin/codex-desktop" << 'EOF'
#!/bin/bash
set -euo pipefail

exec /opt/codex-desktop/start.sh "$@"
EOF
	chmod 755 "${D}/usr/bin/codex-desktop"

	# Install the update manager if built
	if [ -f "${WORK_DIR}/codex-app/update-builder/target/release/codex-update-manager" ]; then
		insinto /usr/bin
		newins "${WORK_DIR}/codex-app/update-builder/target/release/codex-update-manager" \
			codex-update-manager
		chmod 755 "${D}/usr/bin/codex-update-manager"
	fi

	# Install systemd user service
	if [ -f "${S}/packaging/linux/codex-update-manager.service" ]; then
		systemd_dounit "${S}/packaging/linux/codex-update-manager.service"
	fi

	# Install desktop entry
	if [ -f "${S}/packaging/linux/codex-desktop.desktop" ]; then
		domenu "${S}/packaging/linux/codex-desktop.desktop"

		# Update the Exec line to use the correct path
		sed -i 's|/usr/bin/codex-desktop|/usr/bin/codex-desktop|g' \
			"${D}/usr/share/applications/codex-desktop.desktop"
	fi

	# Install icons
	if [ -f "${S}/assets/codex.png" ]; then
		newicon "${S}/assets/codex.png" codex-desktop.png
	fi

	# Install Polkit policy
	if [ -f "${S}/packaging/linux/com.github.ilysenko.codex-desktop-linux.update.policy" ]; then
		insinto /usr/share/polkit-1/actions
		newins "${S}/packaging/linux/com.github.ilysenko.codex-desktop-linux.update.policy" \
			com.github.ilysenko.codex-desktop-linux.update.policy
	fi

	# Install the desktop entry doctor script
	if [ -f "${WORK_DIR}/codex-app/.codex-linux/codex-desktop-entry-doctor.sh" ]; then
		dobin "${WORK_DIR}/codex-app/.codex-linux/codex-desktop-entry-doctor.sh"
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
