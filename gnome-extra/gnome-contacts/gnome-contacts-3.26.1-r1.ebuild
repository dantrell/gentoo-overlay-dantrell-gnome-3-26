# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala meson

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="v4l"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-0.9.6:=
	dev-libs/folks[vala(+)]
	gnome-base/gnome-desktop:3=[introspection]
	gnome-extra/evolution-data-server[vala]
	net-libs/telepathy-glib[vala]
"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
RDEPEND="
	>=dev-libs/folks-0.11.4:=[eds,telepathy]
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libgee-0.10:0.8
	>=gnome-extra/evolution-data-server-3.13.90:=[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3=
	media-libs/clutter:1.0
	media-libs/clutter-gtk:1.0
	media-libs/libchamplain:0.12
	net-libs/gnome-online-accounts:=[vala]
	>=net-libs/telepathy-glib-0.22.0
	>=sci-geosciences/geocode-glib-3.15.3:0
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.20.0:3
	x11-libs/pango
	v4l? ( >=media-video/cheese-3.5.91:= )
"
DEPEND="${RDEPEND}
	${VALA_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-contacts/commit/062acef135a62b530697a8454efa35ce3cdff5a0
	# 	https://gitlab.gnome.org/GNOME/gnome-contacts/commit/9286254274565bcc94a243c2d868fe0b7132a2fb
	"${FILESDIR}"/${PN}-3.27.4-meson-dont-forget-to-install-the-search-provider.patch
	"${FILESDIR}"/${PN}-3.27.4-meson-install-search-provider-to-the-correct-dir.patch
)

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D with-cheese=$(usex v4l true false)
		-D with-manpage=true
	)
	meson_src_configure
}
