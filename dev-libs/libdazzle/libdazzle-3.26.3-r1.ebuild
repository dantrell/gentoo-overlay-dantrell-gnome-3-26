# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson multilib vala

DESCRIPTION="Companion library to GObject and GTK+"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="doc introspection test +vala"

RESTRICT="!test? ( test )"

RDEPEND="
	!x11-libs/libdazzle

	x11-libs/gtk+:3[introspection?]
	introspection? ( dev-libs/gobject-introspection:= )
"
# libxml2 required for glib-compile-resources
DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
	dev-libs/libxml2:2
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

multilib_src_configure() {
	local emesonargs=(
		-D enable_tracing=false
		-D enable_profiling=false
		-D enable_rdtscp=false
		-D enable_tools=true
		-D with_introspection=$(usex introspection true false)
		-D with_vapi=$(usex vala true false)
		-D enable_gtk_doc=$(usex doc true false)
		-D enable_tests=$(usex test true false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
