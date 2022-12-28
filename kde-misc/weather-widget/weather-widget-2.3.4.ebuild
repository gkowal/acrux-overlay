# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#inherit ecm

SRC_URI="https://github.com/blackadderkate/${PN}-2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Plasma 5 applet for weather forecasts"
HOMEPAGE="https://store.kde.org/p/1683743/
https://github.com/blackadderkate/weather-widget-2"

LICENSE="GPL-2+"
SLOT="5"
IUSE=""
S="${WORKDIR}/${PN}-2-${PV}"

DEPEND="
	>=kde-frameworks/plasma-5.60.0:5
"
RDEPEND="${DEPEND}"

DOCS=( README.md )
