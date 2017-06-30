#!/bin/bash
sudo add-apt-repository ppa:dockbar-main/ppa
sudo add-apt-repository ppa:numix/ppa
sudo bash -c 'echo "deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /" >> /etc/apt/sources.list.d/arc-theme.list'
sudo apt update
sudo apt purge evince file-roller gigolo gmusicbrowser gnome-mines gnome-sudoku mousepad mugshot parole software-center thunar-volman thunderbird
sudo apt --purge autoremove
sudo apt dist-upgrade
sudo apt install apache2 arc-theme audacious blender conky-all cryptsetup deja-dup geany geany-plugin-markdown geany-plugins gimp git gnome-disk-utility gnupg2 gparted guvcview inkscape lmms numix-icon-theme-circle php php-curl php-gd php-mcrypt ubuntustudio-fonts virtualbox xarchiver xcalib xfce4-dockbarx-plugin zathura
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo cp config/vhosts.conf /etc/apache2/conf-available/vhosts.conf
sudo a2enconf vhosts
sudo sed -ri 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /etc/php/7.0/apache2/php.ini
sudo service apache2 restart
gsettings set org.blueman.plugins.powermanager auto-power-on false
rsync -Ir config/geany config/gtk-3.0 config/orage config/Thunar config/xfce4 ~/.config
xfconf-query -c keyboard-layout -p /Default/XkbDisable -n -t bool -s false
xfconf-query -c keyboard-layout -p /Default/XkbLayout -n -t string -s us,ru
xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -n -t string -s grp:win_space_toggle
xfconf-query -c keyboard-layout -p /Default/XkbVariant -n -t string -s mac,phonetic
xfconf-query -c thunar -p /last-location-bar -n -t string -s ThunarLocationButtons
xfconf-query -c thunar -p /last-show-hidden -n -t bool -s true
xfconf-query -c thunar -p /last-view -n -t string -s ThunarDetailsView
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 0
xfconf-query -c xfce4-desktop -p /desktop-menu/show -n -t bool -s false
xfconf-query -c xfce4-desktop -p /windowlist-menu/show -n -t bool -s false
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt><Super>8' -n -t string -s 'xcalib -i -a'
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>e' -n -t string -s geany
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/F1 -n -t string -s 'xfce4-terminal --drop-down'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioNext -n -t string -s 'audacious -f'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPlay -n -t string -s 'audacious -t'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPrev -n -t string -s 'audacious -r'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86Music -n -t string -s audacious
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_1' -n -t string -s tile_down_left_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_2' -n -t string -s tile_down_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_3' -n -t string -s tile_down_right_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_4' -n -t string -s tile_left_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_5' -n -t string -s fill_window_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_6' -n -t string -s tile_right_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_7' -n -t string -s tile_up_left_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_8' -n -t string -s tile_up_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Alt>KP_9' -n -t string -s tile_up_right_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift><Alt>Down' -n -t string -s move_window_down_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift><Alt>Left' -n -t string -s move_window_left_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift><Alt>Right' -n -t string -s move_window_right_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift><Alt>Up' -n -t string -s move_window_up_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F1' -n -t string -s move_window_workspace_1_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F10' -n -t string -s move_window_workspace_10_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F11' -n -t string -s move_window_workspace_11_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F12' -n -t string -s move_window_workspace_12_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F2' -n -t string -s move_window_workspace_2_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F3' -n -t string -s move_window_workspace_3_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F4' -n -t string -s move_window_workspace_4_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F5' -n -t string -s move_window_workspace_5_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F6' -n -t string -s move_window_workspace_6_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F7' -n -t string -s move_window_workspace_7_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F8' -n -t string -s move_window_workspace_8_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm/custom/<Primary><Shift>F9' -n -t string -s move_window_workspace_9_key
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
gconftool --load config/dockbarx
cp config/face ~/.face
sudo update-alternatives --set editor /usr/bin/vim.tiny
sudo update-alternatives --set x-cursor-theme /usr/share/icons/DMZ-Black/cursor.theme
echo "set editing-mode vi" > ~/.inputrc
mkdir -p ~/.config/geany/colorschemes
wget -O ~/.config/geany/colorschemes/monokai.conf https://raw.githubusercontent.com/codebrainz/geany-themes/master/colorschemes/monokai.conf
git config --global user.name "Deep Toaster"
git config --global user.email yizhenwilliam@gmail.com
wget https://raw.githubusercontent.com/hotice/webupd8/master/install-google-fonts
chmod +x install-google-fonts
./install-google-fonts
rm install-google-fonts
mkdir -p ~/.fonts
for type in Bold Light Medium Regular Retina
do
	wget -O ~/.fonts/FiraCode-${type}.ttf https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true
done
