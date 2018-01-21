# Copyright 2009-2017 Grzegorz Kowal
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="amd64 x86"
UNIPATCH_STRICTORDER="yes"
UNIPATCH_LIST="${DISTDIR}/${PVR}.tar.gz"

DESCRIPTION="Vanilla sources patched by Custos Mentis for acrux laptop."
SRC_URI="${KERNEL_URI} https://github.com/gkowal/acrux-patchset/archive/${PVR}.tar.gz"

src_install() {
	kernel-2_src_install

	host=`hostname -s`

	if [[ $host == 'callisto' ]]; then
		insinto /usr/src/linux-${PVR}-acrux/include
		newins "${FILESDIR}"/dsdt-callisto.hex dsdt.hex
	fi
}

pkg_postrm() {
	kernel-2_pkg_postrm
}