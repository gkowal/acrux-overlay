# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Dislocker is used to read BitLocker encrypted partitions."
HOMEPAGE="https://github.com/Aorimn/dislocker"

SRC_URI="https://github.com/Aorimn/dislocker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="ruby"

DEPEND="
	sys-fs/fuse:0=
	net-libs/mbedtls:0=
	ruby? ( dev-lang/ruby:* )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-20240607.patch"
)

src_prepare() {
	cmake_src_prepare

# We either need to change Werror to Wno-error or remove the multiple declarations of FORTIFY_SOURCE
#    sed 's:Werror:Wno-error:g' -i "${S}/src/CMakeLists.txt" || die
	sed 's:-D_FORTIFY_SOURCE=2::g' -i "${S}/src/CMakeLists.txt" || die

#	sed 's:\.\./man:'../../${P}/man':g' -i "${S}/src/CMakeLists.txt" || die
# Do not process compressed versions of the manuals
	sed -r 's:( create_symlink \$\{BIN_FUSE\}\.1)\.gz (.+\.1)\.gz\\:\1 \2\\:' -i "${S}/src/CMakeLists.txt" || die
	sed -r 's:^(.+\.1\.gz):#\1:' -i "${S}/src/CMakeLists.txt" || die
}

src_install() {
	if ! use ruby; then
		rm "${S}/man/linux/${PN}-find.1" || die
	fi
	find "${S}/man/linux" -name '*.1' -exec doman '{}' +
	cmake_src_install
}
