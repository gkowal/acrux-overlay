# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel module for BeeGFS parallel cluster filesystem."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://gkowal.info/gentoo/${CATEGORY}/beegfs/beegfs-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/client_module"

MODULES_KERNEL_MAX=6.1

src_compile() {
	local modlist=( beegfs=misc:build )
	local modargs=( KDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
}
