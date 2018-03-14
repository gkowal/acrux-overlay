# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info

DESCRIPTION="OrangeFS is a branch of PVFS2 cluster filesystem"
HOMEPAGE="http://www.orangefs.org/"
SRC_URI="https://s3.amazonaws.com/download.orangefs.org/current/source/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aio apidocs capcache certcache debug doc examples fuse gtk infiniband
kmod-threads ldap memtrace +mmap open-mx reset-file-pos security-key
security-cert sendfile +server ssl static static-libs +tcp +threads
trusted-connections +usrint usrint-cache +usrint-cwd usrint-kmount valgrind"

CDEPEND="
	dev-lang/perl
	>=sys-libs/db-4.8.30:=
	virtual/perl-Math-BigInt
	fuse? ( sys-fs/fuse )
	gtk? ( x11-libs/gtk+:2 )
	infiniband? ( sys-fabric/ofed )
	ldap? ( net-nds/openldap )
	open-mx? ( sys-cluster/open-mx[static-libs?] )
	ssl? ( dev-libs/openssl[static-libs?] )
	valgrind? ( dev-util/valgrind )
"
DEPEND="${CDEPEND}
	>=sys-devel/autoconf-2.59
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	apidocs? ( app-doc/doxygen )
	doc? ( dev-tex/latex2html )
"

# aio and sendfile are only meaningful for kernel module;
# apidocs needs docs to be build first;
# kernel threads obviously needs kernel module and threads
# memtrace and valgrind witout debug info will be a pain;
# if both Myrinet and TCP interfaces are enabled in BMI, 5 sec delays will
# occur, though, at lest one of them must be enabled;
# static flag affects only server, so it must depend on it;
REQUIRED_USE="
	apidocs? ( doc )
	capcache? ( || ( security-cert security-key ) )
	certcache? ( security-cert )
	kmod-threads? ( threads )
	memtrace? ( debug )
	security-cert? ( ldap ssl )
	security-key? ( ssl )
	static? ( server static-libs )
	tcp? ( !infiniband !open-mx )
	usrint-cache? ( usrint )
	usrint-cwd? ( usrint )
	usrint-kmount? ( usrint )
	valgrind? ( debug )
	|| ( infiniband open-mx tcp )
	?? ( security-cert security-key )
"

CONFIG_CHECK="~ORANGEFS_FS"
PATCHES=( "${FILESDIR}/${P}-logfiles.patch" )

pkg_setup() {
	if kernel_is -lt 4 6; then
		eerror "Sorry, linux kernels < 4.6 are not support."
		return 1
	fi
}

src_configure() {
	local myconf="--enable-shared --sysconfdir="${EPREFIX}"/etc/pvfs2"

	use threads && use aio || myconf+=" --disable-aio-threaded-callbacks"

	econf \
	    $(use_enable aio kernel-aio ) \
	    $(use_enable capcache ) \
	    $(use_enable certcache ) \
	    $(use_enable fuse ) \
	    $(use_enable gtk karma ) \
	    $(use_enable mmap racache ) \
	    $(use_enable reset-file-pos ) \
	    $(use_enable security-cert ) \
	    $(use_enable security-key ) \
	    $(use_enable server ) \
	    $(use_enable static static-server ) \
	    $(use_enable static-libs static ) \
	    $(use_enable trusted-connections ) \
	    $(use_enable usrint ) \
	    $(use_enable usrint-cache ucache ) \
	    $(use_enable usrint-cwd ) \
	    $(use_enable usrint-kmount ) \
	    $(use_with infiniband openib "${EPREFIX}"/usr/ ) \
	    $(use_with memtrace mtrace ) \
	    $(use_with ldap ) \
	    $(use_with open-mx mx "${EPREFIX}"/usr/ ) \
	    $(use_with ssl ) \
	    $(use_with tcp bmi-tcp ) \
	    $(use_with valgrind ) \
	    ${myconf}
}

src_install() {
	default

	newinitd "${FILESDIR}"/pvfs2-client-init.d pvfs2-client
	newconfd "${FILESDIR}"/pvfs2-client-conf.d pvfs2-client

	if use server; then
		newinitd "${FILESDIR}"/pvfs2-server-init.d pvfs2-server
		newconfd "${FILESDIR}"/pvfs2-server-conf.d pvfs2-server
	fi

	insinto /etc/pvfs2
	newins examples/fs.conf fs.conf

	dodir "/var/log/${PN}"
}
