# Copyright 2009-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"

inherit kernel-2
detect_version
detect_arch

UNIPATCH_STRICTORDER="yes"
UNIPATCH_LIST="${DISTDIR}/acrux-patchset-${PVR}.tar.gz"

DESCRIPTION="Vanilla sources with additional acrux-patchset."
HOMEPAGE="https://github.com/gkowal/acrux-patchset"
SRC_URI="${KERNEL_URI} https://github.com/gkowal/acrux-patchset/archive/${PVR}.tar.gz -> acrux-patchset-${PVR}.tar.gz"
KEYWORDS="amd64 x86"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
