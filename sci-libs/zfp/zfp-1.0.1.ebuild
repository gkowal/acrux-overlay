# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake fortran-2 python-single-r1

DESCRIPTION="Compressed numerical arrays that support high-speed random access"
HOMEPAGE="https://computing.llnl.gov/projects/zfp"
SRC_URI="https://github.com/LLNL/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+fortran +python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	fortran? ( dev-lang/cfortran )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DZFP_BIT_STREAM_WORD_SIZE:STRING=8
		-DBUILD_ZFORP=$(usex fortran)
		-DBUILD_ZFPY=$(usex python)
	)
	cmake_src_configure
}
