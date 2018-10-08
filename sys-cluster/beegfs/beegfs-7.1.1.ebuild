# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd

DESCRIPTION="BeeGFS (formerly FhGFS) is the leading parallel cluster file system."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v7/-/archive/${PV}/v7-${PV}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="BeeGFS-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client java +modules management meta monitoring storage systemd utils"
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
	java? ( virtual/jdk:1.8 )
"
RDEPEND="${DEPEND}"

src_compile() {
	# build shared libraries
	emake ${MAKEOPTS} ARCH= -C thirdparty/build
	emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C common/build

	if use management; then
		# build management server
		emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C mgmtd/build
	fi

	if use storage; then
		# build storage server
		emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C storage/build
	fi

	if use meta; then
		# build meta server
		emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C meta/build
	fi

	if use monitoring; then
		# build monitoring services
		emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C mon/build
	fi

	if use utils; then
		# build utilities
		if use java; then
			emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" JAVA_HOME=${JAVA_HOME} -C utils/build
		else
			emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C utils/build ctl fsck
		fi
	fi

	if use client; then
		# build helper server
		emake ${MAKEOPTS} BEEGFS_VERSION="${PV}" -C helperd/build
	fi
}

src_install() {
	# install shared libraries
	insinto "/etc/${PN}"
	newlib.so "common/build/libbeegfs_ib.so" "libbeegfs_ib.so"
	keepdir /var/{lib,log}/${PN}

	if use management; then
		# install management server
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
		dodir "/var/lib/${PN}/mgmt"
	fi

	if use storage; then
		# install storage server
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

	if use meta; then
		# install meta server
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

	if use monitoring; then
		# install monitoring services
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
		dosbin "utils/build/beegfs-ctl"
		dosbin "utils/build/beegfs-fsck"
		dosbin "utils/scripts/beegfs-check-servers"
		dosbin "utils/scripts/beegfs-df"
		dosbin "utils/scripts/beegfs-net"
	fi

	if use client; then
		# install helper server
		dosbin "helperd/build/beegfs-helperd"
		newinitd "helperd/build/dist/etc/init.d/beegfs-helperd.init" "beegfs-helperd"
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
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
