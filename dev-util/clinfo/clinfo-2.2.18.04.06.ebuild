# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://github.com/Oblomov/clinfo/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64"

DESCRIPTION="A tool to display info about the system's OpenCL capabilities"
HOMEPAGE="https://github.com/Oblomov/clinfo"
LICENSE="CC0-1.0"
SLOT="0"

DEPEND=">=app-eselect/eselect-opencl-1.1.0-r4
	virtual/opencl"
RDEPEND="${DEPEND}"

src_install() {
	emake MANDIR="${ED}"/usr/share/man PREFIX="${ED}"/usr install
}
