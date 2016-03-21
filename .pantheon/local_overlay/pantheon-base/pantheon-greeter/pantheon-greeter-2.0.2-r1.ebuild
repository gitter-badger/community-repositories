# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION=0.20
VALA_USE_DEPEND=vapigen

inherit gnome2-utils vala cmake-utils

DESCRIPTION="Pantheon Login Screen for LightDM"
HOMEPAGE="https://launchpad.net/pantheon-greeter"
SRC_URI="https://launchpad.net/${PN}/freya/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="nls +vala +introspection"

RDEPEND="
	dev-libs/libindicator:3
	media-fonts/raleway
	media-libs/clutter-gtk:1.0
	virtual/opengl
	x11-libs/granite
	x11-libs/gtk+:3
	>=x11-misc/lightdm-1.2.1"
DEPEND="${DEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"


src_prepare() {
	# Disable generation of the translations (if needed)
	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
 export CFLAGS="$CFLAGS -lm -Wno-deprecated-declarations"

	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}