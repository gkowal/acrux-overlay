# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

DESCRIPTION="Kernel module for BeeGFS parallel cluster filesystem."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v7/-/archive/${PV}/v7-${PV}.tar.bz2 -> beegfs-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
MY_P="v7-${PV}"
S="${WORKDIR}/${MY_P}/client_module"

DEPEND="virtual/linux-sources"

MODULE_NAMES="beegfs(misc:${S}/build)"
BUILD_TARGETS="all"
BUILD_PARAMS="KDIR=${KERNEL_DIR}"

pkg_setup() {
	if kernel_is -gt 5 4; then
		eerror
		eerror "beegfs-kmod is only supported for Linux kernels up to 5.4.x"
		eerror
		die "Downgrade the kernel sources before installing beegfs-kmod."
	fi

	linux-info_pkg_setup
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_compile() {
	# build kernel module
	cd "${S}/source"
	linux-mod_src_compile || die "failed to build driver"
}

src_install() {
	# install kernel module
	cd "${S}/source"
	linux-mod_src_install || die "failed to install driver"
}
