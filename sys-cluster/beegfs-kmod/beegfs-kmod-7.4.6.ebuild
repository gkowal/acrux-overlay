# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel module for BeeGFS parallel cluster filesystem."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://github.com/ThinkParQ/beegfs/archive/${PV}.tar.gz -> beegfs-${PV}.tar.gz"
S="${WORKDIR}/beegfs-${PV}/client_module"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

MODULES_KERNEL_MAX=6.11

src_compile() {
	local modlist=( beegfs=misc:build )
	local modargs=( KDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
}
