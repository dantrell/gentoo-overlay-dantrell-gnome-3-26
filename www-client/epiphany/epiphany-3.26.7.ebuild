# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson xdg virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web https://gitlab.gnome.org/GNOME/epiphany"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.52.0:2[dbus]
	>=x11-libs/gtk+-3.22.13:3
	>=dev-libs/nettle-3.2:=
	>=net-libs/webkit-gtk-2.17.4:4=
	>=x11-libs/cairo-1.2
	>=app-crypt/gcr-3.5.5:0=[gtk]
	>=x11-libs/gdk-pixbuf-2.36.5:2
	>=gnome-base/gnome-desktop-2.91.2:3=
	dev-libs/icu:=
	>=app-text/iso-codes-0.35
	>=dev-libs/json-glib-1.2.4
	>=x11-libs/libnotify-0.5.1:=
	>=app-crypt/libsecret-0.14
	>=net-libs/libsoup-2.48:2.4
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	dev-db/sqlite:3
	dev-libs/gmp:0=
	>=gnome-base/gsettings-desktop-schemas-0.0.1
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
# paxctl needed for bug #407085
# appstream-glib needed for appdata.xml gettext translation
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	sys-apps/paxctl
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddeveloper_mode=false
		-Ddistributor_name=Gentoo
		-Dhttps_everywhere=false
		-Dunit_tests=$(usex test true false)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}
