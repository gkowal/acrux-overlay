# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION="7.2"

inherit cmake rocm

DESCRIPTION="Port of Facebook's LLaMA model in C/C++"
HOMEPAGE="https://github.com/ggml-org/llama.cpp"

MY_PV="b${PV#0_pre}"
SRC_URI="https://github.com/ggml-org/llama.cpp/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/llama.cpp-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

CPU_FLAGS_X86=( avx avx2 f16c avx512f avx512_vnni avx512_bf16 avx512vbmi )
IUSE="curl openblas +openmp rocm vulkan ${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}"

REQUIRED_USE="
	rocm? ( ${ROCM_REQUIRED_USE} )
"

RDEPEND="
	curl? ( net-misc/curl:= )
	openblas? ( sci-libs/openblas:= )
	rocm? (
		>=dev-util/hip-${ROCM_VERSION}:=
		>=sci-libs/hipBLAS-${ROCM_VERSION}:=[${ROCM_USEDEP}]
	)
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
		-DGGML_HIP=$(usex rocm ON OFF)
		-DGGML_OPENMP=$(usex openmp ON OFF)
		-DGGML_CURL=$(usex curl ON OFF)
		-DGGML_NATIVE=OFF
		-DBUILD_SHARED_LIBS=ON
		-DGGML_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DGGML_F16C=$(usex cpu_flags_x86_f16c ON OFF)
		-DGGML_AVX512=$(usex cpu_flags_x86_avx512f ON OFF)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni ON OFF)
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512_bf16 ON OFF)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512vbmi ON OFF)
	)

	if use openblas; then
		mycmakeargs+=(
			-DGGML_BLAS_VENDOR=OpenBLAS
		)
	fi

	if use rocm; then
		rocm_use_hipcc
		mycmakeargs+=(
			-DGPU_TARGETS="$(get_amdgpu_flags)"
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		)
	fi

	cmake_src_configure
}
