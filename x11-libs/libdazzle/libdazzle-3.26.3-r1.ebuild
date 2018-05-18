# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson multilib python-r1 vala

DESCRIPTION="Companion library to GObject and GTK+"
HOMEPAGE="https://github.com/chergert/libdazzle"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+vala"

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/gobject-introspection:=
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
