# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Partition cloning tool"
HOMEPAGE="https://partclone.org"
SRC_URI="https://github.com/Thomas-Tsai/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="apfs btrfs +exfat +f2fs +fat fuse +hfs isal jfs ncurses +ntfs nilfs reiserfs static ufs vmfs +xfs xxhash"

RDEPEND="
	app-arch/zstd:=
	dev-libs/openssl:=
	sys-apps/util-linux:=
	virtual/zlib:=
	btrfs? ( sys-fs/btrfs-progs )
	fuse? ( sys-fs/fuse:3 )
	isal? ( dev-libs/isa-l )
	jfs? ( sys-fs/jfsutils )
	ncurses? ( sys-libs/ncurses:= )
	nilfs? ( sys-fs/nilfs-utils )
	ntfs? ( sys-fs/ntfs3g )
	reiserfs? ( sys-fs/progsreiserfs )
	xxhash? ( dev-libs/xxhash )
	xfs? (
		dev-libs/userspace-rcu:=
		>=sys-fs/xfsprogs-3.1.11-r1
	)
	static? (
		app-arch/zstd[static-libs]
		dev-libs/openssl[static-libs]
		dev-libs/xxhash[static-libs(+)]
		sys-apps/util-linux[static-libs]
		sys-libs/ncurses[static-libs]
		virtual/zlib[static-libs]
		btrfs? ( sys-fs/btrfs-progs[static-libs] )
		ntfs? ( sys-fs/ntfs3g[static-libs] )
		reiserfs? ( sys-fs/reiserfsprogs[static-libs] )
		xfs? (
			dev-libs/userspace-rcu[static-libs]
			>=sys-fs/xfsprogs-3.1.11-r1[static-libs]
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-extfs \
		--enable-fs-test \
		$(use_enable apfs) \
		$(use_enable btrfs) \
		$(use_enable exfat) \
		$(use_enable f2fs) \
		$(use_enable fat) \
		$(use_enable fuse) \
		$(use_enable hfs hfsp) \
		$(use_enable isal) \
		$(use_enable jfs) \
		$(use_enable ncurses ncursesw) \
		$(use_enable nilfs nilfs2) \
		$(use_enable ntfs) \
		$(use_enable reiserfs) \
		--disable-reiser4 \
		$(use_enable static static-linking) \
		$(use_enable ufs) \
		$(use_enable vmfs) \
		$(use_enable xxhash) \
		$(use_enable xfs)
}
