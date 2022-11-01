# Calculators

## TiLP

Download and install TiLP from <http://lpg.ticalc.org/prj_tilp/linux.html>.

Launch with `sudo tilp`.

## TilEm

Installation:

1.  Download TilEm sources from
    <http://lpg.ticalc.org/prj_tilem/download.html>.
2.  Change to `LIBS = -lm` in tilem-2.0/gui/Makefile.
3.  Install as normal.

# Development

## LaTeX

Installation:

1.  Download and install TeX Live from
    <https://www.tug.org/texlive/acquire-netinstall.html>.
2.  Append `PATH="/usr/local/texlive/2014/bin/x86_64-linux:$PATH"` to
    ~/.profile and /root/.bashrc.

Alternatively, the installation of geany-plugins (see below) should include a
full, correctly-placed install of TeX Live.

## Alternative Python versions

1.      `sudo add-apt-repository ppa:deadsnakes/ppa`
2.      `sudo apt install python$OTHER_VERSION-dev python$OTHER_VERSION-distutils`
3.      `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$OTHER_VERSION 1`
4.      `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$CURRENT_VERSION 2`

## Fritzing

Installation:

1.      `sudo apt install fritzing fritzing-parts`
2.  Append `Path=/usr/share/fritzing/parts` to
    /usr/share/applications/fritzing.desktop.

## Geany

Set line-breaking to 80 in _Edit > Preferences > Editor > Features_ and _Edit >
Preferences > Editor > Display_.

Add keyboard shortcut `<Primary><Alt>s` > _Save As_.

Add `&& rm "%e.aux" "%e.log" "%e.out"` to the end of each LaTeX build command.

## Geany plugins

    sudo apt install geany-plugins geany-plugin-markdown

Set Web helper preview pane to _Sidebar_.

Change any external open commands to `thunar "%d"` and show all hidden files.

## Emmet

Installation:

1.  Download and extract the emmet folder from
    <https://github.com/sergeche/emmet-sublime> to the result of `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`.
2.  Download and extract editor.js and geanypy-emmet.py from
    <https://github.com/sagarchalise/geanypy-emmet> to
    /usr/share/geany/geanypy/plugins.

# Media

## Audacious

    sudo apt install audacious xubuntu-restricted-extras

Add keyboard shortcuts:

- `XF86AudioPlay` => `audacious -t`
- `XF86AudioStop` => `audacious -s`
- `XF86AudioPrev` => `audacious -r`
- `XF86AudioNext` => `audacious -f`

Enable the following plugins:

- Status Icon
- Scrobbler 2.0

## Mixxx

1.      sudo apt install libjack-jackd2-dev
2.      sudo apt install portaudio19-dev
3.      sudo apt build-dep mixxx
4.      sudo apt install libfaad-dev libmp4v2-dev

## Bluetooth

Installation:

1.      sudo apt install pulseaudio-module-bluetooth
2.  Add `Disable=Socket` under `[General]` to /etc/bluetooth/audio.conf.
3.      gsettings get org.blueman.plugins.powermanager auto-power-on

# Miscellaneous

## Desktop sharing

Installation:

1.      sudo apt install vino
2.      gsettings set org.gnome.Vino require-encryption false

Show in menus by commenting out the `OnlyShowIn` line in
/usr/share/applications/vino-preferences.desktop.

Launch with `/usr/lib/vino/vino-server`.

## Display tweaks

Enable backlight controls:

1.  Change to `GRUB_CMDLINE_LINUX="acpi_osi=Linux acpi_backlight=vendor"` in
    /etc/default/grub.
2.      sudo update-grub
3.      sudo apt install xbacklight
4.  Enable _Power manager settings > General > Handle display brightness keys_.

Enable inverted colors:

1.      sudo apt install xcalib
2.  Add keyboard shortcut `Ctrl+Alt+Super+8` => `xcalib -i -a`.

## Peripherals

To disable the trackpad, comment out the `SoftButtonAreas` and
`SecondarySoftButtonAreas` lines in
/usr/share/X11/xorg.conf.d/70-synaptics.conf.

## Power Statistics

    sudo apt install gnome-power-manager

Show in menus by commenting out the `OnlyShowIn` line in
/usr/share/applications/gnome-power-statistics.desktop.

## Webcam

    sudo apt install guvcview

Change file paths in _Video > File_ and _Photo > File_ to default locations in
~/Videos and ~/Pictures, respectively.
