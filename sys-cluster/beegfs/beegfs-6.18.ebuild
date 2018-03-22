# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd

DESCRIPTION="BeeGFS (formerly FhGFS) is the leading parallel cluster file system."
HOMEPAGE="https://beegfs.io/"
SRC_URI="https://git.beegfs.io/pub/v6/repository/${PV}/archive.tar.bz2 -> ${P}.tar.bz2"
LICENSE="BeeGFS"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="client infiniband java +modules management meta rdma storage systemd utils"
MY_P="v6-${PV}-aee03250ea19502952d2f187e73134996abaec5b"
S="${WORKDIR}/${MY_P}"

DEPEND="
	>=dev-db/sqlite-3.0
	dev-libs/openssl
	dev-util/cppunit
	sys-apps/attr
	sys-devel/libtool
	sys-fs/xfsprogs
	sys-libs/zlib
	infiniband? ( sys-fabric/libibverbs )
	modules? ( =sys-cluster/${PN}-kmod-${PV} )
	rdma? ( sys-fabric/librdmacm )
	java? ( virtual/jdk )
"
RDEPEND="${DEPEND}"

src_compile() {
	# build shared libraries
	emake ${MAKEOPTS} ARCH= -C beegfs_thirdparty/build
	if use infiniband; then
		emake ${MAKEOPTS} USER_LDFLAGS="-fPIC -Wl,-soname,libbeegfs-opentk.so.6" BEEGFS_OPENTK_IBVERBS=1 -C beegfs_opentk_lib/build
	else
		emake ${MAKEOPTS} USER_LDFLAGS="-fPIC -Wl,-soname,libbeegfs-opentk.so.6" BEEGFS_OPENTK_IBVERBS=0 -C beegfs_opentk_lib/build
	fi
	emake ${MAKEOPTS} -C beegfs_common/build

	if use management; then
		# build management server
		emake ${MAKEOPTS} -C beegfs_mgmtd/build
	fi

	if use storage; then
		# build storage server
		emake ${MAKEOPTS} -C beegfs_storage/build
	fi

	if use meta; then
		# build meta server
		emake ${MAKEOPTS} -C beegfs_meta/build
	fi

	if use utils; then
		# build utilities
		if use java; then
			emake ${MAKEOPTS} JAVA_HOME=${JAVA_HOME} -C beegfs_utils/build
		else
			emake ${MAKEOPTS} -C beegfs_utils/build beegfs_ctl beegfs_fsck
		fi
	fi

	if use client; then
		# build helper server
		emake ${MAKEOPTS} -C beegfs_helperd/build
	fi
}

src_install() {
	# install shared libraries
	insinto "/etc/${PN}"
	newins "beegfs_opentk_lib/build/dist/etc/beegfs/beegfs-libopentk.conf" "beegfs-libopentk.conf"
	newlib.so "beegfs_opentk_lib/build/libbeegfs-opentk.so" "libbeegfs-opentk.so.${PV}"
	ln -s "libbeegfs-opentk.so.${PV}" ${D}/usr/lib64/"libbeegfs-opentk.so.6"
	ln -s "libbeegfs-opentk.so.6" ${D}/usr/lib64/"libbeegfs-opentk.so"
	keepdir /var/{lib,log}/${PN}

	if use management; then
		# install management server
		dosbin "beegfs_mgmtd/build/beegfs-mgmtd"
		dosbin "beegfs_mgmtd/build/dist/sbin/beegfs-setup-mgmtd"
		newinitd "${FILESDIR}/${PN}-mgmtd.init" "${PN}-mgmtd"
		newconfd "${FILESDIR}/${PN}-mgmtd.confd" "${PN}-mgmtd"
		insinto "/etc/${PN}"
		newins "beegfs_mgmtd/build/dist/etc/beegfs-mgmtd.conf" "${PN}-mgmtd.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-mgmtd.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-mgmtd.service"
		fi

		# Create storage directory for the management server
		dodir "/var/lib/${PN}/mgmt"
	fi

	if use storage; then
		# install storage server
		dosbin "beegfs_storage/build/beegfs-storage"
		dosbin "beegfs_storage/build/dist/sbin/beegfs-setup-storage"
		newinitd "${FILESDIR}/${PN}-storage.init" "${PN}-storage"
		newconfd "${FILESDIR}/${PN}-storage.confd" "${PN}-storage"
		insinto "/etc/${PN}"
		newins "beegfs_storage/build/dist/etc/beegfs-storage.conf" "${PN}-storage.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-storage.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-storage.service"
		fi
	fi

	if use meta; then
		# install meta server
		dosbin "beegfs_meta/build/beegfs-meta"
		dosbin "beegfs_meta/build/dist/sbin/beegfs-setup-meta"
		newinitd "${FILESDIR}/${PN}-meta.init" "${PN}-meta"
		newconfd "${FILESDIR}/${PN}-meta.confd" "${PN}-meta"
		insinto "/etc/${PN}"
		newins "beegfs_meta/build/dist/etc/beegfs-meta.conf" "${PN}-meta.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-meta.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-meta.service"
		fi
	fi

	if use utils; then
		# install utilities
		dosbin "beegfs_utils/build/beegfs-ctl"
		dosbin "beegfs_utils/build/beegfs-fsck"
		dosbin "beegfs_utils/scripts/beegfs-check-servers"
		dosbin "beegfs_utils/scripts/beegfs-df"
		dosbin "beegfs_utils/scripts/beegfs-net"
	fi

	if use client; then
		# install helper server
		dosbin "beegfs_helperd/build/beegfs-helperd"
		newinitd "beegfs_helperd/build/dist/etc/init.d/beegfs-helperd.init" "beegfs-helperd"
		newinitd "${FILESDIR}/${PN}-helperd.init" "${PN}-helperd"
		newconfd "${FILESDIR}/${PN}-helperd.confd" "${PN}-helperd"
		insinto "/etc/${PN}"
		newins "beegfs_helperd/build/dist/etc/beegfs-helperd.conf" "${PN}-helperd.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-helperd.conf"
		if use systemd; then
			systemd_dounit "${FILESDIR}/${PN}-helperd.service"
		fi

		# install client services and kernel module
		dosbin "beegfs_client_module/build/dist/sbin/beegfs-setup-client"
		insinto "/etc/${PN}"
		newins "beegfs_client_module/build/dist/etc/beegfs-client.conf" "beegfs-client.conf"
		sed -i "s/\/var\/log/\/var\/log\/beegfs/g" "${D}/etc/${PN}/${PN}-client.conf"
	fi
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
	fi
}
