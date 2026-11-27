# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Export smartctl statistics to Prometheus"
HOMEPAGE="https://github.com/prometheus-community/smartctl_exporter"
SRC_URI="https://github.com/prometheus-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://gentoo.clarokowal.com/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="amd64"

BDEPEND=">=dev-lang/go-1.26.0"
RDEPEND="sys-apps/smartmontools"

PATCHES=(
	"${FILESDIR}/${P}-describe-scsi-metrics.patch"
)

src_compile() {
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%Y%m%d-%H:%M:%S)"
	)
	ego build -ldflags "${go_ldflags[*]}" -o ${PN} .
}

src_test() {
	ego test ./...
}

src_install() {
	dobin ${PN}
	dodoc CHANGELOG.md EXAMPLE.md README.md

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.{service,socket}
	insinto /etc/sysconfig
	newins "${FILESDIR}"/${PN}.sysconfig ${PN}
}
