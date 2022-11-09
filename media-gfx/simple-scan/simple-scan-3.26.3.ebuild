# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_MAX_API_VERSION="0.40"

inherit gnome2 vala meson

DESCRIPTION="Simple document scanning utility"
HOMEPAGE="https://launchpad.net/simple-scan"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

IUSE="+colord"

DEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/libgusb:=[vala]
	>=media-gfx/sane-backends-1.0.20:=
	>=sys-libs/zlib-1.2.3.1:=
	media-libs/libjpeg-turbo:0=
	x11-libs/cairo:=
	>=x11-libs/gtk+-3:3
	colord? ( >=x11-misc/colord-0.1.24:=[udev(+),vala] )
"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
"
BDEPEND="
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}
