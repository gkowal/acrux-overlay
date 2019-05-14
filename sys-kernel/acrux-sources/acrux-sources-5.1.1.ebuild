# Copyright 2009-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="amd64 ~x86"
UNIPATCH_STRICTORDER="yes"
UNIPATCH_LIST="${DISTDIR}/${PVR}.tar.gz"

DESCRIPTION="Vanilla sources with additional acrux-patchset."
HOMEPAGE="https://github.com/gkowal/acrux-patchset"
SRC_URI="${KERNEL_URI} https://github.com/gkowal/acrux-patchset/archive/${PVR}.tar.gz"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
