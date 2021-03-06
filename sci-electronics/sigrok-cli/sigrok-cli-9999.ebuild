# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

#WANT_AUTOCONF="latest" # 2.63 or newer
#WANT_AUTOMAKE="latest" # 1.11 or newer
PYTHON_COMPAT=( python3_{2,3,4} )
inherit eutils autotools python-single-r1

if [ ${PV} = 9999 ]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Command-line client for the sigrok logic analyzer software"
HOMEPAGE="http://sigrok.org/"

REQUIRED_USE="sigrokdecode? ( ${PYTHON_REQUIRED_USE} )"
LICENSE="GPL-3"
SLOT="0"
IUSE="+sigrokdecode"

RDEPEND=">=sci-electronics/libsigrok-0.3.0
	sigrokdecode? ( >=sci-electronics/libsigrokdecode-0.3.0 ${PYTHON_DEPS} )
	>=dev-libs/glib-2.28.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
# >=dev-util/pkgconfig-0.22

pkg_setup () {
	python-single-r1_pkg_setup
}

src_prepare() {
	if [ ${PV} = 9999 ]; then
		eautoreconf
	fi
}

src_configure() {
	# >=sigrok-cli-0.5.0's configure.ac is broken
	if ! use sigrokdecode; then
		# or --with-libsigrokdecode=anything_can_go_here
		my_args=--without-libsigrokdecode
	else
		my_args=
	fi
	econf "$my_args"
}
