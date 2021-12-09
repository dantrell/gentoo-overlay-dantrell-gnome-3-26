# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME utility for installing and updating applications"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="flatpak +firmware gnome gtk-doc spell sysprof udev"

RDEPEND="
	>=dev-libs/appstream-glib-0.7.0:0
	>=x11-libs/gdk-pixbuf-2.31.5:2
	>=x11-libs/gtk+-3.20.0:3
	>=dev-libs/glib-2.46:2
	>=dev-libs/json-glib-1.1.1
	app-crypt/libsecret
	>=net-libs/libsoup-2.51.92:2.4
	dev-db/sqlite:3
	gnome? ( >=gnome-base/gsettings-desktop-schemas-3.17.92 )
	spell? ( app-text/gtkspell:3 )
	sys-auth/polkit
	firmware? ( >=sys-apps/fwupd-0.9.7 )
	flatpak? (
		>=sys-apps/flatpak-0.6.3
		dev-util/ostree
	)
	udev? ( dev-libs/libgudev )
	>=gnome-base/gsettings-desktop-schemas-3.11.5
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
"

src_prepare() {
	xdg_src_prepare
	sed -i -e '/install_data.*README\.md.*share\/doc\/gnome-software/d' meson.build || die
	# We don't need language packs download support, and it fails tests in 3.34.2 for us (if they are enabled)
	sed -i -e '/subdir.*fedora-langpacks/d' plugins/meson.build || die
	# Trouble talking to spawned gnome-keyring socket for some reason, even if wrapped in dbus-run-session
	sed -i -e '/g_test_add_func.*gs_auth_secret_func/d' lib/gs-self-test.c || die
}

src_configure() {
	local emesonargs=(
		-Denable-tests=false
		$(meson_use spell enable-gtkspell)
		$(meson_use gnome enable-gnome-desktop) # Honoring of GNOME date format settings.
		-Denable-man=true
		-Denable-packagekit=false
		-Denable-polkit=true
		$(meson_use firmware enable-fwupd)
		$(meson_use flatpak enable-flatpak)
		-Denable-ostree=false
		-Denable-limba=false
		-Denable-rpm=false
		-Denable-rpm-ostree=false
		-Denable-steam=false
		$(meson_use gnome enable-shell-extensions) # Maybe gnome-shell USE?
		-Denable-odrs=false
		-Denable-ubuntuone=false
		-Denable-ubuntu-reviews=false
		-Denable-webapps=true
		$(meson_use udev enable-gudev)
		-Denable-snap=false
		-Denable-external_appstream=false
		-Denable-valgrind=false
		$(meson_use gtk-doc enable-gtk-doc)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
