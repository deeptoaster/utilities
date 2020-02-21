Calculators
===========

TiLP
----

Download and install TiLP from <http://lpg.ticalc.org/prj_tilp/linux.html>.

Launch with `sudo tilp`.


TilEm
-----

Installation:

1.  Download TilEm sources from
    <http://lpg.ticalc.org/prj_tilem/download.html>.
2.  Change to `LIBS = -lm` in tilem-2.0/gui/Makefile.
3.  Install as normal.


Development
===========

LaTeX
-----

Installation:

1.  Download and install TeX Live from
    <https://www.tug.org/texlive/acquire-netinstall.html>.
2.  Append `PATH="$PATH:/usr/local/texlive/2014/bin/x86_64-linux"` to
    ~/.profile.

Alternatively, the installation of geany-plugins (see below) should include a
full, correctly-placed install of TeX Live.


Fritzing
--------

Installation:

1.      `sudo apt install fritzing fritzing-parts`
2.  Append `Path=/usr/share/fritzing/parts` to
    /usr/share/applications/fritzing.desktop.


Geany
-----

Set line-breaking to 80 in *Edit > Preferences > Editor > Features* and *Edit >
Preferences > Editor > Display*.

Add keyboard shortcut `<Primary><Alt>s` > *Save As*.

Add ` && rm "%e.aux" "%e.log" "%e.out"` to the end of each LaTeX build command.


Geany plugins
-------------

    sudo apt install geany-plugins geany-plugin-markdown

Set Web helper preview pane to *Sidebar*.

Change any external open commands to `thunar "%d"` and show all hidden files.


Emmet
-----

Installation:

1.  Download and extract the emmet folder from
    <https://github.com/sergeche/emmet-sublime> to the result of `python -c
    "from distutils.sysconfig import get_python_lib; print get_python_lib()"`.
2.  Download and extract editor.js and geanypy-emmet.py from
    <https://github.com/sagarchalise/geanypy-emmet> to
    /usr/share/geany/geanypy/plugins.


LAMP stack
==========

Apache
------

    sudo apt install apache2

To allow sites from mounted USB devices, change `APACHE_RUN_USER` and
`APACHE_RUN_GROUP` in /etc/apache2/envvars to the current user and group,
respectively.

Enable .htaccess files by changing to `AllowOverride All` in
/etc/apache2/apache2.conf.

Enable automatic virtual hosts:

1.      sudo a2enmod vhost_alias
2.  Add the following script to Apache configuration:

        NameVirtualHost *:80

        <VirtualHost *:80>
            ServerName default
            DocumentRoot /var/www/html
        </VirtualHost>

        <VirtualHost *:80>
            ServerName virtual
            ServerAlias *.localhost
            VirtualDocumentRoot /var/www/%-2
        </VirtualHost>

3.  Add any desired virtual hosts as 127.0.0.1 in /etc/hosts.
4.  For any desired virtual host of the form *.PART.localhost, place its files
    under /var/www/PART.


PHP
---

    sudo apt install php php-curl php-gd php-mcrypt libapache2-mod-php

Enable short tags by changing to `short_open_tag = On` in
/etc/php/7.0/apache2/php.ini.

Enable short tags by changing to `display_errors = On` in
/etc/php/7.0/apache2/php.ini.


MySQL
-----

Installation:

1.      sudo apt install mysql-server php5-mysql
2.      sudo mysql_install_db
3.      sudo mysql_secure_installation


Media
=====

Audacious
---------

    sudo apt install audacious xubuntu-restricted-extras

Add keyboard shortcuts:

*   `XF86AudioPlay` => `audacious -t`
*   `XF86AudioStop` => `audacious -s`
*   `XF86AudioPrev` => `audacious -r`
*   `XF86AudioNext` => `audacious -f`

Enable the following plugins:

*   Status Icon
*   Scrobbler 2.0


Mixxx
-----

1.      sudo apt install libjack-jackd2-dev
2.      sudo apt install portaudio19-dev
3.      sudo apt build-dep mixxx
4.      sudo apt install libfaad-dev libmp4v2-dev


Bluetooth
---------

Installation:

1.      sudo apt install pulseaudio-module-bluetooth
2.  Add `Disable=Socket` under `[General]` to /etc/bluetooth/audio.conf.
3.      gsettings get org.blueman.plugins.powermanager auto-power-on


Miscellaneous
=============

Backups
-------

    sudo apt install deja-dup

Add Thunar custom actions:

*   `Revert to Previous Version` => `deja-dup --restore %F` on all but
    *Directories*.
*   `Restore Missing Files` => `deja-dup --restore-missing %f` on
    *Directories*.


Desktop sharing
---------------

Installation:

1.      sudo apt install vino
2.      gsettings set org.gnome.Vino require-encryption false

Show in menus by commenting out the `OnlyShowIn` line in
/usr/share/applications/vino-preferences.desktop.

Launch with `/usr/lib/vino/vino-server`.


Display tweaks
--------------

Enable backlight controls:

1.  Change to `GRUB_CMDLINE_LINUX="acpi_osi=Linux acpi_backlight=vendor"` in
    /etc/default/grub.
2.      sudo update-grub
3.      sudo apt install xbacklight
4.  Enable *Power manager settings > General > Handle display brightness keys*.

Enable inverted colors:

1.      sudo apt install xcalib
2.  Add keyboard shortcut `Ctrl+Alt+Super+8` => `xcalib -i -a`.


Fonts
-----

The Ubuntu Studio fonts are available from `ubuntustudio-font-meta`. Google Web
Fonts are available from
`https://github.com/hotice/webupd8/blob/master/install-google-fonts`. Fira Code
is available from `https://github.com/tonsky/FiraCode`.


Peripherals
-----------

To disable the trackpad, comment out the `SoftButtonAreas` and
`SecondarySoftButtonAreas` lines in
/usr/share/X11/xorg.conf.d/70-synaptics.conf.


Power Statistics
----------------

    sudo apt install gnome-power-manager

Show in menus by commenting out the `OnlyShowIn` line in
/usr/share/applications/gnome-power-statistics.desktop.


VirtualBox
----------

Installation:

1.      sudo apt install virtualbox
2.  Download and install extension pack from
    <https://www.virtualbox.org/wiki/Downloads>.

USB access:

1.  Add `woot` to `vboxusers` group in /etc/group.
2.  Check *Settings > USB > Enable USB 2.0 (EHCI) Controller* for each OS that
    supports it.


Webcam
------

    sudo apt install guvcview

Change file paths in *Video > File* and *Photo > File* to default locations in
~/Videos and ~/Pictures, respectively.


Window manager
--------------

Enable unfocused scrolling by unchecking *Window Manager Tweaks >
Accessibility > Raise windows when any mouse button is pressed*.

Enable scrollwheel to shade on window title by checking *Window Manager Tweaks
> Accessibility > Use mouse wheel on title bar to roll up the window*.

Add keyboard shortcuts:

*   `Ctrl+Alt+5` => *Fill window*
*   `Shift+Ctrl+Alt+Up` => *Move window to upper workspace*
*   `Shift+Ctrl+Alt+Down` => *Move window to bottom workspace*
*   `Shift+Ctrl+Alt+Left` => *Move window to left workspace*
*   `Shift+Ctrl+Alt+Right` => *Move window to right workspace*
*   `Ctrl+Alt+8` => *Tile window to the top*
*   `Ctrl+Alt+2` => *Tile window to the bottom*
*   `Ctrl+Alt+4` => *Tile window to the left*
*   `Ctrl+Alt+6` => *Tile window to the right*

If keyboard shortcuts do not work after reboot, be sure to clear each shortcut
completely (by clicking Clear twice) before adding it again.
