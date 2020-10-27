# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Partition cloning tool"
HOMEPAGE="https://partclone.org"
SRC_URI="https://github.com/Thomas-Tsai/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="btrfs exfat f2fs +fat hfs jfs ncurses +ntfs reiser4 reiserfs static vmfs +xfs"

RDEPEND="sys-fs/e2fsprogs
	btrfs? ( sys-fs/btrfs-progs )
	exfat? ( sys-fs/exfat-utils )
	f2fs? ( sys-fs/f2fs-tools )
	fat? ( sys-fs/dosfstools )
	hfs? ( sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	ncurses? ( sys-libs/ncurses )
	ntfs? ( sys-fs/ntfs3g )
	reiser4? ( sys-fs/reiser4progs )
	reiserfs? ( sys-fs/progsreiserfs )
	xfs? ( >=sys-fs/xfsprogs-3.1.11-r1 )
	static? ( sys-libs/ncurses[static-libs]
		  sys-fs/e2fsprogs[static-libs]
		  sys-fs/btrfs-progs[static-libs]
		  sys-fs/ntfs3g[static-libs]
		  sys-fs/reiser4progs[static-libs]
		  sys-fs/reiserfsprogs[static-libs]
		 )"
DEPEND=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
	    --enable-extfs --enable-fs-test \
	    $(use_enable ncurses ncursesw ) \
	    $(use_enable static ) \
	    $(use_enable btrfs ) \
	    $(use_enable exfat ) \
	    $(use_enable f2fs ) \
	    $(use_enable fat ) \
	    $(use_enable hfs hfsp ) \
	    $(use_enable jfs ) \
	    $(use_enable ntfs ) \
	    $(use_enable reiserfs ) \
	    $(use_enable reiser4 ) \
	    $(use_enable vmfs ) \
	    $(use_enable xfs )
}
