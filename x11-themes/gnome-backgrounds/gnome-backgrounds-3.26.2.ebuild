# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-backgrounds"

LICENSE="CC-BY-SA-2.0 CC-BY-SA-3.0 CC-BY-2.0"
SLOT="0"
KEYWORDS="*"

IUSE="vanilla-live"

RDEPEND="!<x11-themes/gnome-themes-standard-3.14"
DEPEND=">=sys-devel/gettext-0.19.8"

src_prepare() {
	if ! use vanilla-live; then
		cp "${FILESDIR}"/"${PN}"-3.14.1-restore-3.10-backgrounds/* "${S}"/backgrounds
	fi

	gnome2_src_prepare
}
