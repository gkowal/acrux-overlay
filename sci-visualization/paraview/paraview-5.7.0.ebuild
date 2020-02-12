# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit cmake-utils desktop python-single-r1 qmake-utils toolchain-funcs xdg-utils

MAIN_PV=$(ver_cut 0-1)
MAJOR_PV=$(ver_cut 1-2)
MY_P="ParaView-v${PV}"

DESCRIPTION="Powerful scientific data visualization application"
HOMEPAGE="https://www.paraview.org"
SRC_URI="https://www.paraview.org/files/v${MAJOR_PV}/${MY_P}.tar.xz"

LICENSE="paraview GPL-2"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="coprocessing development examples ffmpeg mpi nvcontrol openmp offscreen plugins python +qt5 test tk visit"

RESTRICT="mirror test"

REQUIRED_USE="python? ( mpi ${PYTHON_REQUIRED_USE} )
	?? ( offscreen qt5 )"

RDEPEND="
	app-arch/lz4
	dev-libs/expat
	dev-libs/libxml2:2
	dev-libs/protobuf:=
	media-libs/freetype
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/tiff:0=
	sci-libs/hdf5:=[mpi=]
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	coprocessing? (
		plugins? (
			dev-python/PyQt5
			dev-qt/qtgui:5[-gles2]
		)
	)
	ffmpeg? ( virtual/ffmpeg )
	mpi? ( virtual/mpi[cxx,romio] )
	offscreen? ( >=media-libs/mesa-18.3.6[osmesa] )
	!offscreen? ( virtual/opengl )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/matplotlib[${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		')
	)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtgui:5[-gles2]
		dev-qt/qthelp:5
		dev-qt/qtopengl:5[-gles2]
		dev-qt/qtsql:5
		dev-qt/qttest:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtx11extras:5
	)
	tk? ( dev-lang/tk:0= )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.1-xdmf-cstring.patch
	"${FILESDIR}"/${PN}-5.3.0-fix_buildsystem.patch
	"${FILESDIR}"/${PN}-5.5.0-allow_custom_build_type.patch
	"${FILESDIR}"/${PN}-5.7.0-fix_openmp_4.0.patch
)

CMAKE_MAKEFILE_GENERATOR="emake" #579474

pkg_setup() {
	[[ ${MERGE_TYPE} != "binary" ]] && use openmp && tc-check-openmp
	python-single-r1_pkg_setup
	PVLIBDIR=$(get_libdir)/${PN}-${MAJOR_PV}
}

src_prepare() {

	# Bug #661812
	mkdir -p Plugins/StreamLinesRepresentation/doc || die

	cmake-utils_src_prepare

	# lib64 fixes
	sed -i \
		-e "s:/lib/python:/$(get_libdir)/python:g" \
		VTK/ThirdParty/xdmf3/vtkxdmf3/CMakeLists.txt || die
	sed -i \
		-e "s:lib/paraview-:$(get_libdir)/paraview-:g" \
		ParaViewCore/ServerManager/SMApplication/vtkInitializationHelper.cxx || die
}

src_configure() {
	if use qt5; then
		export QT_SELECT=qt5
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${PVLIBDIR}"
		-DPARAVIEW_BUILD_SHARED_LIBS=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON

		-DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=TRUE

		-DVTK_USE_OGGTHEORA_ENCODER=TRUE

		# coprocessing
		-DPARAVIEW_ENABLE_CATALYST="$(usex coprocessing)"

		# examples
		-DBUILD_EXAMPLES="$(usex examples)"

		# ffmpeg
		-DPARAVIEW_ENABLE_FFMPEG="$(usex ffmpeg)"
		-DVTK_USE_FFMPEG_ENCODER="$(usex ffmpeg)"

		# mpi
		-DPARAVIEW_USE_ICE_T="$(usex mpi)"
		-DPARAVIEW_USE_MPI_SSEND="$(usex mpi)"
		-DPARAVIEW_USE_MPI="$(usex mpi)"
		-DXDMF_BUILD_MPI="$(usex mpi)"

		# VitIt bridge
		-DPARAVIEW_ENABLE_VISITBRIDGE="$(usex visit)"

		# offscreen
		-DVTK_USE_X=$(usex !offscreen)
		-DVTK_OPENGL_HAS_OSMESA=$(usex offscreen)

		# plugins
		-DPARAVIEW_PLUGIN_ENABLE_ArrowGlyph="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_EyeDomeLighting="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_GMVReader="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_Moments="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_NonOrthogonalSource="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_PacMan="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_SierraPlotTools="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_SLACTools="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_StreamingParticles="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_SurfaceLIC="$(usex plugins)"
		-DPARAVIEW_PLUGIN_ENABLE_pvNVIDIAIndeX="$(usex plugins)"

		# python
		-DModule_pqPython="$(usex python)"
		-DPARAVIEW_ENABLE_PYTHON="$(usex python)"

		# qt5
		-DPARAVIEW_INSTALL_DEVELOPMENT_FILES="$(usex development)"
		-DPARAVIEW_BUILD_QT_GUI="$(usex qt5)"
		-DModule_pqPython="$(usex qt5 "$(usex python)" "off")"
		-DVTK_USE_NVCONTROL="$(usex nvcontrol)"

		# test
		-DBUILD_TESTING="$(usex test)"

		# tk
		-DVTK_USE_TK="$(usex tk)"
	)

	if use openmp; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE=OpenMP )
	fi

	if use qt5; then
		mycmakeargs+=(
			-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
			-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
			-DQT_MOC_EXECUTABLE="$(qt5_get_bindir)/moc"
		)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# set up the environment
	echo "LDPATH=${EPREFIX}/usr/${PVLIBDIR}" > "${T}/40${PN}" || die
	doenvd "${T}/40${PN}"

	newicon "${S}/Applications/ParaView/pvIcon-32x32.png" paraview.png
	make_desktop_entry paraview "Paraview" paraview

	use python && python_optimize "${D}/usr/$(get_libdir)/${PN}-${MAJOR_PV}"

	mv "${ED}/usr/share/licenses" "${ED}/usr/share/doc/${P}/"
	mv "${ED}/usr/share/vtkm-1.3" "${ED}/usr/share/doc/${P}/"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
