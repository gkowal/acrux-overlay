# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="Utility to find btrfs compression ratio"
HOMEPAGE="https://github.com/kilobyte/compsize"
SRC_URI="https://github.com/kilobyte/compsize/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"

LICENSE="GPL-2+"
SLOT=0

RDEPEND=""
DEPEND="sys-fs/btrfs-progs"

src_prepare() {
	eapply_user
	# Don't try to install a gzipped manfile during make install, instead
	# use doman in src_install to ensure that PORTAGE_COMPRESS is used
	sed -i $'/^\tgzip /d' Makefile || die
}

src_configure() {
	# Used in upstream Makefile, but clobbered by portage's CFLAGS
	append-cflags -Wall -std=gnu90
	default
}

src_install() {
	emake PREFIX="${ED%/}" install
	doman compsize.8
	einstalldocs
}
