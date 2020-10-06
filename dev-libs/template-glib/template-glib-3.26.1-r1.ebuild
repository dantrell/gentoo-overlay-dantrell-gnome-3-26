# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson multilib-minimal vala

DESCRIPTION="Templating library for GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/template-glib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="debug +introspection +vala"

RDEPEND="
	>=dev-libs/glib-2.53.4:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
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
