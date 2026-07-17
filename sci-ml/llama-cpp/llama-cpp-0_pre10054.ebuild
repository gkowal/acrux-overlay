# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Port of Facebook's LLaMA model in C/C++"
HOMEPAGE="https://github.com/ggml-org/llama.cpp"

MY_PV="b${PV#0_pre}"
SRC_URI="https://github.com/ggml-org/llama.cpp/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/llama.cpp-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

IUSE="curl openblas +openmp vulkan"

RDEPEND="
	curl? ( net-misc/curl:= )
	openblas? ( sci-libs/openblas:= )
	vulkan? ( media-libs/vulkan-loader:= )
"
DEPEND="${RDEPEND}
	vulkan? (
		dev-util/vulkan-headers
	)
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DGGML_BLAS=$(usex openblas ON OFF)
		-DGGML_VULKAN=$(usex vulkan ON OFF)
		-DGGML_OPENMP=$(usex openmp ON OFF)
		-DGGML_CURL=$(usex curl ON OFF)
		-DGGML_NATIVE=OFF
		-DBUILD_SHARED_LIBS=ON
	)

	if use openblas; then
		mycmakeargs+=(
			-DGGML_BLAS_VENDOR=OpenBLAS
		)
	fi

	cmake_src_configure
}
