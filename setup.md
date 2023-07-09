# Calculators

## TiLP

Download and install TiLP from <http://lpg.ticalc.org/prj_tilp/linux.html>.

Launch with `sudo tilp`.

## TilEm

1.  Download TilEm sources from
    <http://lpg.ticalc.org/prj_tilem/download.html>.
2.  Change to `LIBS = -lm` in tilem-2.0/gui/Makefile.
3.  Install as normal.

# Development

## Alternative Python versions

1.  `sudo add-apt-repository ppa:deadsnakes/ppa`
2.  `sudo apt install python$OTHER_VERSION-dev python$OTHER_VERSION-distutils`
3.  `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$OTHER_VERSION 1`
4.  `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$CURRENT_VERSION 2`

## Fritzing

1.  `sudo apt install fritzing fritzing-parts`
2.  Append `Path=/usr/share/fritzing/parts` to
    /usr/share/applications/fritzing.desktop.

# Media

## Audacious

1.  sudo apt install audacious xubuntu-restricted-extras
2.  Add keyboard shortcuts:
    - `XF86AudioPlay` => `audacious -t`
    - `XF86AudioStop` => `audacious -s`
    - `XF86AudioPrev` => `audacious -r`
    - `XF86AudioNext` => `audacious -f`
3.  Enable the following plugins:
    - Status Icon
    - Scrobbler 2.0

## Mixxx

1.  `sudo apt install libjack-jackd2-dev`
2.  `sudo apt install portaudio19-dev`
3.  `sudo apt build-dep mixxx`
4.  `sudo apt install libfaad-dev libmp4v2-dev`

# Miscellaneous

## Desktop sharing

1.  `sudo apt install vino`
2.  `gsettings set org.gnome.Vino require-encryption false`
3.  Comment out the `OnlyShowIn` line in
    /usr/share/applications/vino-preferences.desktop.

Launch with `/usr/lib/vino/vino-server`.

## Power Statistics

1.  `sudo apt install gnome-power-manager`
2.  Comment out the `OnlyShowIn` line in
    /usr/share/applications/gnome-power-statistics.desktop.

# macOS

## Apache

Use System Settings -> Privacy & Security -> Full Disk Access to add
/usr/sbin/httpd.

## PHP

1.  Use Keychain Access to create a certificate authority for code signing
    named `woot`.
2.  Trust the certificate authority that was created.
3.  `codesign --sign woot --force --keychain ~/Library/Keychains/login.keychain-db /opt/homebrew/opt/php/lib/httpd/modules/libphp.so`
