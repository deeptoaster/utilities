#!/bin/bash
sudo add-apt-repository ppa:dockbar-main/ppa
sudo add-apt-repository ppa:numix/ppa
sudo bash -c 'echo "deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /" >> /etc/apt/sources.list.d/arc-theme.list'
sudo apt update
sudo apt purge evince file-roller gigolo gmusicbrowser gnome-mines gnome-sudoku mousepad mugshot parole software-center thunar-volman thunderbird
sudo apt --purge autoremove
sudo apt dist-upgrade
sudo apt install apache2 arc-theme audacious blender cryptsetup deja-dup geany geany-plugin-markdown geany-plugins gimp git gnome-disk-utility gnupg2 gparted guvcview inkscape lmms numix-icon-theme-circle php php-curl php-gd php-mcrypt ubuntustudio-font-meta xarchiver xcalib xfce4-dockbarx-plugin zathura
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo cp config/vhosts.conf /etc/apache2/conf-available/vhosts.conf
sudo a2enconf vhosts
sudo sed -ri 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /etc/php/7.0/apache2/php.ini
sudo service apache2 restart
gsettings set org.blueman.plugins.powermanager auto-power-on false
xfconf-query -c keyboard-layout -p /Default/XkbDisable -n -t bool -s false
xfconf-query -c keyboard-layout -p /Default/XkbLayout -n -t string -s us,ru
xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -n -t string -s grp:win_space_toggle
xfconf-query -c keyboard-layout -p /Default/XkbVariant -n -t string -s mac,phonetic
xfconf-query -c thunar -p /last-location-bar -n -t string -s ThunarLocationButtons
xfconf-query -c thunar -p /last-show-hidden -n -t bool -s true
xfconf-query -c thunar -p /last-view -n -t string -s ThunarDetailsView
xfconf-query -c xfce4-desktop -p /commands/custom/F1 -n -t string -s 'xfce4-terminal --drop-down'
xfconf-query -c xfce4-keyboard-shortcuts -p /desktop-icons/style -n -t int -s 0
xfconf-query -c xfce4-keyboard-shortcuts -p /desktop-menu -n -t bool -s false
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt><Super>8' -n -t string -s 'xcalib -i -a'
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>e' -n -t string -s geany
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioNext -n -t string -s 'audacious -f'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPlay -n -t string -s 'audacious -t'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPrev -n -t string -s 'audacious -r'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86Music -n -t string -s audacious
xfconf-query -c xfce4-panel -p / -r -R
xfconf-query -c xfce4-panel -p /configver -n -t int -s 2
xfconf-query -c xfce4-panel -p /panels -n -t uint -s 1
xfconf-query -c xfce4-panel -p /panels/panel-0/autohide-behavior -n -t uint -s 0
xfconf-query -c xfce4-panel -p /panels/panel-0/background-alpha -n -t uint -s 50
xfconf-query -c xfce4-panel -p /panels/panel-0/background-style -n -t uint -s 1
xfconf-query -c xfce4-panel -p /panels/panel-0/disable-struts -n -t bool -s true
xfconf-query -c xfce4-panel -p /panels/panel-0/length -n -t uint -s 100
xfconf-query -c xfce4-panel -p /panels/panel-0/plugin-ids -n -t int -t int -t int -t int -t int -t int -t int -t int -t int -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9
xfconf-query -c xfce4-panel -p /panels/panel-0/position -n -t string -s 'p=6;x=0;y=0'
xfconf-query -c xfce4-panel -p /panels/panel-0/position-locked -n -t bool -s true
xfconf-query -c xfce4-panel -p /panels/panel-0/size -n -t uint -s 24
xfconf-query -c xfce4-panel -p /panels/panel-0/span-monitors -n -t bool -s false
xfconf-query -c xfce4-panel -p /plugins/notes/new-window/always-on-top -n -t bool -s true
xfconf-query -c xfce4-panel -p /plugins/notes/new-window/sticky -n -t bool -s false
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -n -t string -s applicationsmenu
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -n -t string -s go-down-symbolic
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-title -n -t string -s ' Applications '
xfconf-query -c xfce4-panel -p /plugins/plugin-2 -n -t string -s places
xfconf-query -c xfce4-panel -p /plugins/plugin-2/button-label -n -t string -s ' Emplacements '
xfconf-query -c xfce4-panel -p /plugins/plugin-2/show-button-type -n -t int -s 1
xfconf-query -c xfce4-panel -p /plugins/plugin-3 -n -t string -s dockbarx
xfconf-query -c xfce4-panel -p /plugins/plugin-4 -n -t string -s systray
xfconf-query -c xfce4-panel -p /plugins/plugin-4/show-frame -n -t bool -s false
xfconf-query -c xfce4-panel -p /plugins/plugin-5 -n -t string -s power-manager-plugin
xfconf-query -c xfce4-panel -p /plugins/plugin-6 -n -t string -s xkb-plugin
xfconf-query -c xfce4-panel -p /plugins/plugin-7 -n -t string -s indicator
xfconf-query -c xfce4-panel -p /plugins/plugin-8 -n -t string -s xfce4-orageclock-plugin
xfconf-query -c xfce4-panel -p /plugins/plugin-9 -n -t string -s pager
xfconf-query -c xfce4-panel -p /plugins/plugin-9/rows -n -t uint -s 2
xfconf-query -c xfwm4 -p /general/button_layout -n -t string -s 'CMH|O'
xfconf-query -c xfwm4 -p /general/frame_opacity -n -t int -s 80
xfconf-query -c xfwm4 -p /general/mousewheel_rollup -n -t bool -s true
xfconf-query -c xfwm4 -p /general/popup_opacity -n -t int -s 80
xfconf-query -c xfwm4 -p /general/raise_with_any_button -n -t bool -s false
xfconf-query -c xfwm4 -p /general/show_dock_shadow -n -t bool -s false
xfconf-query -c xfwm4 -p /general/show_popup_shadow -n -t bool -s true
xfconf-query -c xfwm4 -p /general/snap_to_windows -n -t bool -s true
xfconf-query -c xfwm4 -p /general/title_font -n -t string -s 'Neuropol 9'
xfconf-query -c xfwm4 -p /general/workspace_count -n -t int -s 4
xfconf-query -c xfwm4 -p /general/wrap_cycle -n -t bool -s false
xfconf-query -c xfwm4 -p /general/wrap_layout -n -t bool -s false
xfconf-query -c xfwm4 -p /general/wrap_windows -n -t bool -s false
xfconf-query -c xsettings -p /Gtk/ButtonImages -n -t bool -s false
xfconf-query -c xsettings -p /Gtk/CursorThemeName -n -t string -s DMZ-Black
xfconf-query -c xsettings -p /Gtk/DecorationLayout -n -t string -s close,maximize,minimize:menu
xfconf-query -c xsettings -p /Gtk/FontName -n -t string -s 'Droid Sans 10'
xfconf-query -c xsettings -p /Gtk/MenuImages -n -t bool -s false
xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s Numix-Circle
cp config/xfce4-orageclock-plugin-8.rc ~/.config/xfce4/panel/xfce4-orageclock-plugin-8.rc
cp config/dockbarx-3.rc ~/.config/xfce4/panel/dockbarx-3.rc
gconftool --load ~/Documents/utilities/config/dockbarx
xfce4-panel --restart
cp config/face ~/.face
sudo update-alternatives --set editor /usr/bin/vim.tiny
sudo update-alternatives --set x-cursor-theme /usr/share/icons/DMZ-Black/cursor.theme
echo "set editing-mode vi" > ~/.inputrc
wget -O ~/.config/geany/colorschemes/monokai.conf https://raw.githubusercontent.com/codebrainz/geany-themes/master/colorschemes/monokai.conf
cp config/filetypes.latex .config/geany/filedefs/filetypes.latex
git config --global user.name "Deep Toaster"
git config --global user.email yizhenwilliam@gmail.com
wget https://raw.githubusercontent.com/hotice/webupd8/master/install-google-fonts
chmod +x install-google-fonts
./install-google-fonts
rm install-google-fonts
