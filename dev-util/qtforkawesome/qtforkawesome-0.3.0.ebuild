# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library that bundles ForkAwesome for use within Qt applications"
HOMEPAGE="https://github.com/Martchus/qtforkawesome"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ForkAwesome/Fork-Awesome/archive/refs/tags/1.2.0.tar.gz -> Fork-Awesome-1.2.0.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6=[gui]
	>=dev-util/cpp-utilities-5.5.0:=
	>=dev-util/qtutilities-6.3.0:=
"
DEPEND="${RDEPEND}
	dev-lang/perl
	|| ( dev-perl/YAML-LibYAML dev-perl/YAML )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DFORK_AWESOME_FONT_FILE="${WORKDIR}/Fork-Awesome-1.2.0/fonts/forkawesome-webfont.woff2"
		-DFORK_AWESOME_ICON_DEFINITIONS="${WORKDIR}/Fork-Awesome-1.2.0/src/icons/icons.yml"
		-DQT_PACKAGE_PREFIX=Qt6
	)

	cmake_src_configure
}
