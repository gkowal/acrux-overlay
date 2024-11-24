# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DOCS_BUILDER="doxygen"
inherit cmake flag-o-matic desktop docs python-single-r1 qmake-utils toolchain-funcs xdg

MAJOR_PV="$(ver_cut 1-2)"
MINOR_PV="$(ver_cut 3)"
MY_P="ParaView-v${MAJOR_PV}.${MINOR_PV}"

DESCRIPTION="Powerful scientific data visualization application"
HOMEPAGE="https://www.paraview.org"
SRC_URI="https://www.paraview.org/files/v${MAJOR_PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD MIT PSF-2 VTK"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="boost cg examples ffmpeg mpi nvcontrol nvindex openmp offscreen plugins python qt5 +qt6 +sqlite test visit +webengine"

RESTRICT="mirror test"

REQUIRED_USE="
	python? ( mpi ${PYTHON_REQUIRED_USE} )
	webengine? ( qt6 )
	qt5? ( sqlite )
	qt6? ( sqlite )
	?? ( doc qt6 )
	?? ( offscreen qt5 )
	?? ( offscreen qt6 )"

RDEPEND="
	app-arch/lz4
	dev-libs/expat
	dev-libs/jsoncpp:=
	dev-libs/libxml2:2
	dev-libs/protobuf:=
	dev-libs/pugixml
	media-libs/freetype
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/libtheora
	media-libs/tiff:=
	sci-libs/cgnslib
	sci-libs/hdf5:=[mpi=]
	>=sci-libs/netcdf-4.2[hdf5]
	>=sci-libs/netcdf-cxx-4.2:3
	sys-libs/zlib
	virtual/glu
	media-libs/libjpeg-turbo:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	ffmpeg? ( media-video/ffmpeg )
	mpi? ( virtual/mpi[cxx,romio] )
	offscreen? ( >=media-libs/mesa-18.3.6[osmesa] )
	!offscreen? ( virtual/opengl )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/constantly[${PYTHON_USEDEP}]
			dev-python/incremental[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/sip:5[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			dev-python/twisted[${PYTHON_USEDEP}]
			dev-python/zope-interface[${PYTHON_USEDEP}]
			mpi? ( dev-python/mpi4py )
			qt5? ( dev-python/pyqt5[opengl,${PYTHON_USEDEP}] )
		')
	)
	qt6? (
		dev-qt/qtdeclarative:6
		dev-qt/qtsvg:6
		webengine? ( dev-qt/qtwebengine:6[widgets] )
	)
	!qt6? (
		qt5? (
			dev-qt/designer:5
			dev-qt/qtdeclarative:5
			dev-qt/qtgui:5[-gles2-only]
			dev-qt/qthelp:5
			dev-qt/qtopengl:5[-gles2-only]
			dev-qt/qtsql:5
			dev-qt/qtsvg:5
			dev-qt/qttest:5
			dev-qt/qtx11extras:5
			dev-qt/qtxmlpatterns:5
			webengine? ( dev-qt/qtwebengine:5[widgets] )
		)
	)
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	boost? (
		$(python_gen_cond_dep '
			dev-libs/boost[mpi?,python,${PYTHON_USEDEP}]
		')
	)
"

BDEPEND="
	openmp? ( virtual/fortran )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.0-allow_custom_build_type.patch
)

# false positive when checking for available HDF5 interface, bug #904731
QA_CONFIG_IMPL_DECL_SKIP=(
	H5Pset_coll_metadata_write
	H5Pset_all_coll_metadata_ops
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	use python && python-single-r1_pkg_setup
	PVLIBDIR=$(get_libdir)/${PN}-${MAJOR_PV}
}

src_prepare() {
	# Bug #661812
	mkdir -p Plugins/StreamLinesRepresentation/doc || die

	cmake_src_prepare

	# lib64 fixes
	sed -i \
		-e "s:/lib/python:/$(get_libdir)/python:g" \
		VTK/ThirdParty/xdmf3/vtkxdmf3/CMakeLists.txt || die
	sed -i \
		-e "s:lib/paraview-:$(get_libdir)/paraview-:g" \
		Remoting/Application/vtkInitializationHelper.cxx || die
}

src_configure() {
	# Needed to compile bundled VTK in ParaView 5.11.1 with gcc 12
	# see also, bug #863299
	filter-lto
	append-cflags $(test-flags-CC -fno-strict-aliasing \
		-Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion)
	append-cxxflags $(test-flags-CXX -fno-strict-aliasing \
		-Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion)

	# Make sure qmlplugindump is in path:
	if use qt6; then
		export PATH="$(qt6_get_bindir):${PATH}"
	else
		if use qt5; then
			export PATH="$(qt5_get_bindir):${PATH}"
		fi
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${PVLIBDIR}"
		-UBUILD_SHARED_LIBS
		-DPARAVIEW_BUILD_SHARED_LIBS=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON

		# boost
		-DVTK_MODULE_ENABLE_VTK_IOInfovis="$(usex boost YES NO)"

		# doc
		-DPARAVIEW_BUILD_DEVELOPER_DOCUMENTATION="$(usex doc)"

		# examples
		-DBUILD_EXAMPLES="$(usex examples)"

		# ffmpeg
		-DPARAVIEW_ENABLE_FFMPEG="$(usex ffmpeg)"

		# mpi
		-DPARAVIEW_USE_MPI="$(usex mpi)"
		-DXDMF_BUILD_MPI="$(usex mpi)"
		-DVTK_GROUP_ENABLE_MPI="$(usex mpi YES NO)"

		# offscreen
		-DVTK_OPENGL_HAS_OSMESA="$(usex offscreen)"
		-DVTK_OPENGL_HAS_OSMESA="$(usex offscreen)"

		# plugins
		-DPARAVIEW_PLUGINS_DEFAULT="$(usex plugins)"

		# NVidia IndeX
		-DPARAVIEW_PLUGIN_ENABLE_pvNVIDIAIndeX="$(usex nvindex)"

		# VisIt
		-DPARAVIEW_ENABLE_VISITBRIDGE="$(usex visit)"

		# python
		-DModule_pqPython="$(usex python)"
		-DPARAVIEW_USE_PYTHON="$(usex python)"

		# sqlite
		-DVTK_MODULE_ENABLE_VTK_sqlite="$(usex sqlite YES NO)"

		# test
		-DBUILD_TESTING="$(usex test)"

		# webengine
		-DPARAVIEW_USE_QTWEBENGINE="$(usex webengine)"
		-DVTK_GROUP_ENABLE_Web="$(usex webengine YES NO)"
	)

		# qt
	if use qt6; then
		mycmakeargs+=(
			-DPARAVIEW_USE_QT="$(usex qt6)"
			-DPARAVIEW_QT_VERSION="6"
			-DVTK_QT_VERSION="6"
			-DModule_pqPython="$(usex qt6 "$(usex python)" "off")"
			-DVTK_USE_NVCONTROL="$(usex nvcontrol)"
			-DVTK_GROUP_ENABLE_Qt="$(usex qt6 YES NO)"
			-DCMAKE_INSTALL_QMLDIR="${EPREFIX}/usr/$(get_libdir)/qt6/qml"
		)
	else
		if use qt5; then
			mycmakeargs+=(
				-DPARAVIEW_USE_QT="$(usex qt5)"
				-DPARAVIEW_QT_VERSION="5"
				-DVTK_QT_VERSION="5"
				-DModule_pqPython="$(usex qt5 "$(usex python)" "off")"
				-DVTK_USE_NVCONTROL="$(usex nvcontrol)"
				-DVTK_GROUP_ENABLE_Qt="$(usex qt5 YES NO)"
				-DCMAKE_INSTALL_QMLDIR="${EPREFIX}/usr/$(get_libdir)/qt5/qml"
			)
		fi
	fi

	if use openmp; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE=OpenMP )
	fi

	if use qt6; then
		mycmakeargs+=(
			-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
			-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
		)
	else
		if use qt5; then
			mycmakeargs+=(
				-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
				-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
				-DQT_MOC_EXECUTABLE="$(qt5_get_bindir)/moc"
				-Dqt_xmlpatterns_executable="$(qt5_get_bindir)/xmlpatterns"
			)
	fi
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove wrapper binaries and put the actual executable in place
	for i in {paraview-config,pvserver,pvdataserver,pvrenderserver,pvbatch,pvpython,paraview}; do
		if [ -f "${ED}"/usr/lib/"$i" ]; then
			mv "${ED}"/usr/lib/"$i" "${ED}"/usr/bin/"$i" || die
		fi
	done

	# set up the environment
	echo "LDPATH=${EPREFIX}/usr/${PVLIBDIR}" > "${T}"/40${PN} || die
	doenvd "${T}"/40${PN}

	newicon "${S}"/Clients/ParaView/pvIcon-96x96.png paraview.png
	make_desktop_entry paraview "Paraview" paraview

	use python && python_optimize "${ED}/usr/$(get_libdir)/${PN}-${MAJOR_PV}"
}
