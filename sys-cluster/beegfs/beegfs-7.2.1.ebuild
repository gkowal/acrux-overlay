# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils systemd

DESCRIPTION="BeeGFS (formerly FhGFS) is the leading parallel cluster file system."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v7/-/archive/${PV}/v7-${PV}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="BeeGFS-EULA"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="client +modules management meta monitoring storage systemd utils"
MY_P="v7-${PV}"
S="${WORKDIR}/${MY_P}"

DEPEND="
	>=dev-db/sqlite-3.0
	dev-libs/openssl:0
	dev-util/cppunit
	sys-apps/attr
	sys-devel/libtool
	sys-fabric/libibverbs
	sys-fabric/librdmacm
	sys-fs/xfsprogs
	sys-libs/zlib
	modules? ( ~sys-cluster/${PN}-kmod-${PV} )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-7.2-error_nu.patch"
)

src_compile() {
	local targets

	if use client; then
		targets="${targets} helperd-all"
	fi
	if use management; then
		targets="${targets} mgmtd-all"
	fi
	if use meta; then
		targets="${targets} meta-all"
	fi
	if use storage; then
		targets="${targets} storage-all"
	fi
	if use monitoring; then
		targets="${targets} mon-all"
	fi
	if use utils; then
		targets="${targets} utils"
	fi

	emake BEEGFS_VERSION="${PV}" ${targets}
}

src_install() {
	# create required directories
	insinto "/etc/${PN}"
	keepdir /var/{lib,log}/${PN}

	# install shared libraries
	newlib.so "common/build/libbeegfs_ib.so" "libbeegfs_ib.so"

	if use client; then
		# install helper daemon
		dosbin "helperd/build/beegfs-helperd"
		newinitd "${FILESDIR}/${PN}-helperd.init" "${PN}-helperd"
		newconfd "${FILESDIR}/${PN}-helperd.confd" "${PN}-helperd"
		insinto "/etc/${PN}"
		newins "helperd/build/dist/etc/beegfs-helperd.conf" "${PN}-helperd.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-helperd.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-helperd.service"
		fi

		# install client services and kernel module
		dosbin "client_module/build/dist/sbin/beegfs-setup-client"
		insinto "/etc/${PN}"
		newins "client_module/build/dist/etc/beegfs-client.conf" "beegfs-client.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-client.conf"
	fi

	if use management; then
		# install management daemon
		dosbin "mgmtd/build/beegfs-mgmtd"
		dosbin "mgmtd/build/dist/sbin/beegfs-setup-mgmtd"
		newinitd "${FILESDIR}/${PN}-mgmtd.init" "${PN}-mgmtd"
		newconfd "${FILESDIR}/${PN}-mgmtd.confd" "${PN}-mgmtd"
		insinto "/etc/${PN}"
		newins "mgmtd/build/dist/etc/beegfs-mgmtd.conf" "${PN}-mgmtd.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-mgmtd.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-mgmtd.service"
		fi

		# Create storage directory for the management server
		keepdir "/var/lib/${PN}/mgmt"
	fi

	if use meta; then
		# install meta daemon
		dosbin "meta/build/beegfs-meta"
		dosbin "meta/build/dist/sbin/beegfs-setup-meta"
		newinitd "${FILESDIR}/${PN}-meta.init" "${PN}-meta"
		newconfd "${FILESDIR}/${PN}-meta.confd" "${PN}-meta"
		insinto "/etc/${PN}"
		newins "meta/build/dist/etc/beegfs-meta.conf" "${PN}-meta.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-meta.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-meta.service"
		fi
	fi

	if use storage; then
		# install storage daemon
		dosbin "storage/build/beegfs-storage"
		dosbin "storage/build/dist/sbin/beegfs-setup-storage"
		newinitd "${FILESDIR}/${PN}-storage.init" "${PN}-storage"
		newconfd "${FILESDIR}/${PN}-storage.confd" "${PN}-storage"
		insinto "/etc/${PN}"
		newins "storage/build/dist/etc/beegfs-storage.conf" "${PN}-storage.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-storage.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-storage.service"
		fi
	fi

	if use monitoring; then
		# install monitoring daemon
		dosbin "mon/build/beegfs-mon"
		newinitd "${FILESDIR}/${PN}-mon.init" "${PN}-mon"
		newconfd "${FILESDIR}/${PN}-mon.confd" "${PN}-mon"
		insinto "/etc/${PN}"
		newins "mon/build/dist/etc/beegfs-mon.conf" "${PN}-mon.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-mon.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-mon.service"
		fi
	fi

	if use utils; then
		# install utilities
		dosbin "ctl/build/beegfs-ctl"
		dosbin "fsck/build/beegfs-fsck"
		dosbin "utils/scripts/beegfs-check-servers"
		dosbin "utils/scripts/beegfs-df"
		dosbin "utils/scripts/beegfs-net"
	fi
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
