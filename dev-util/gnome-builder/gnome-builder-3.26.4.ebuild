# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_5,3_6,3_7,3_8} )
VALA_MIN_API_VERSION="0.30"
VALA_USE_DEPEND="vapigen"
DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1
GNOME2_ECLASS_ICONS=1
GNOME2_ECLASS_GLIB_SCHEMAS=1
VALA_USE_DEPEND="vapigen"

inherit gnome2 python-single-r1 vala virtualx readme.gentoo-r1 meson

DESCRIPTION="Builder attempts to be an IDE for writing software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

# FIXME: Review licenses at some point
LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="*"

IUSE="clang +git sysprof +vala webkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Tests fail if all plugins aren't enabled (webkit, clang, devhelp, perhaps more)
RESTRICT="test"

# When bumping, pay attention to all the included plugins/*/configure.ac files and the requirements within.
# Most have no extra requirements and default to enabled; we need to handle the ones with extra requirements, which tend to default to auto(magic).
# Look at the last (fourth) argument given to AC_ARG_ENABLE to decide. We don't support any disabling of those that are default-enabled and have no extra deps beyond C/python/introspection.
# FIXME: >=dev-util/devhelp-3.20.0 dependency is automagic for devhelp integration plugin
# FIXME: vte could be optional via $(use_enable vte terminal-plugin) - but most/all people want this and have vte?
# FIXME: flatpak-plugin needs flatpak.pc >=0.6.9, libgit2[threads] >=libgit2-glib-0.24.0[ssh] libsoup-2.4.pc
# FIXME: --with-sanitizer configure option
# FIXME: Enable rdtscp based high performance counter usage on suitable architectures for EGG_COUNTER?
# Editorconfig needs pcre.h, with vte migrating away, might want it optional?
# Python is always enabled - the core python plugin support checks are automagic and not worth crippling it by not supporting python plugins
# Relatedly introspection is always required to not have broken python using plugins or have to enable/disable them based on it. This is a full IDE, not a place to be really minimal.
# An introspection USE flag of a dep is required if any introspection based language plugin wants to use it. Last full check at 3.22.4
RDEPEND="
	>=x11-libs/gtk+-3.22.1:3[introspection]
	>=dev-libs/glib-2.50.0:2[dbus]
	>=x11-libs/gtksourceview-3.22.0:3.0[introspection,vala?]
	>=dev-libs/gobject-introspection-1.48.0:=
	>=dev-python/pygobject-3.22.0:3
	>=dev-libs/libxml2-2.9.0
	>=x11-libs/pango-1.38.0
	>=dev-libs/libpeas-1.21[python,${PYTHON_USEDEP}]
	>=dev-libs/json-glib-1.2.0
	>=app-text/gspell-1.2.0
	>=app-text/enchant-1.6.0:0=
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4=[introspection] )
	clang? ( sys-devel/clang:= )
	git? (
		dev-libs/libgit2[ssh,threads]
		>=dev-libs/libgit2-glib-0.25.0[ssh] )
	>=x11-libs/vte-0.46:2.91
	sysprof? ( >=dev-util/sysprof-3.23.91[gtk] )
	dev-libs/libpcre:3
	${PYTHON_DEPS}
	vala? ( $(vala_depend) )
	>=dev-libs/libdazzle-3.25
	>=dev-libs/template-glib-3.25
	>=dev-libs/jsonrpc-glib-3.25
	dev-util/devhelp
	dev-python/jedi
	dev-python/lxml
"
# desktop-file-utils for desktop-file-validate check in configure for 3.22.4
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	!<sys-apps/sandbox-2.10-r3
"

DOC_CONTENTS='gnome-builder can use various other dependencies on runtime to provide
extra capabilities beyond these expressed via USE flags. Some of these
that are currently available with packages include:

* dev-util/ctags with exuberant-ctags selected via "eselect ctags" for
  C, C++, Python, JavaScript, CSS, HTML and Ruby autocompletion, semantic
  highlighting and symbol resolving support.
* dev-util/valgrind for integration with valgrind.
'
# FIXME: Package gnome-code-assistance and mention here, or maybe USE flag and default enable because it's rather important
# eslint for additional diagnostics in JavaScript files
# jhbuild support
# rust language server via rls
# autotools stuff for autotools plugin; gtkmm/autoconf-archive for C++ template
# mono/PHPize stuff

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D with_editorconfig=true
		-D with_introspection=true
		-D with_vala_pack=$(usex vala true false)
		-D with_webkit=$(usex webkit true false)
		-D with_html_preview=$(usex webkit true false)
		-D with_html_completion=$(usex webkit true false)
		-D with_clang=$(usex clang true false)
		-D with_git=$(usex git true false)
		-D with_sysprof=$(usex sysprof true false)
		-D with_flatpak=false
		-D with_terminal=true
		-D with_gettext=true
		-D with_gettext=true
		-D with_gdb=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data/gsettings" || die
}
