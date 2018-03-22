# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-mod

DESCRIPTION="Kernel module for BeeGFS (formerly FhGFS), the leading parallel cluster file system."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v6/repository/${PV}/archive.tar.bz2 -> beegfs-${PV}.tar.bz2"
LICENSE="BeeGFS"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
MY_P="v6-${PV}-aee03250ea19502952d2f187e73134996abaec5b"
S="${WORKDIR}/${MY_P}"

DEPEND="virtual/linux-sources"
RDEPEND="virtual/modutils"

MODULE_NAMES="beegfs(misc:${S}/beegfs_client_module/build)"

pkg_setup() {
	linux-info_pkg_setup
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_compile() {
	# build kernel module
	cd "${S}/beegfs_client_module/source"
	linux-mod_src_compile || die "failed to build driver"
}

src_install() {
	# install kernel module
	cd "${S}/beegfs_client_module/source"
	linux-mod_src_install || die "failed to install driver"
}
