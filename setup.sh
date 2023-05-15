#!/bin/bash
set -x
trap read debug
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
sudo add-apt-repository ppa:numix/ppa
sudo add-apt-repository ppa:xubuntu-dev/extras
wget -O - https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo apt-key add -
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt purge thunar-volman vim-tiny xfce4-whiskermenu-plugin xpdf
sudo apt dist-upgrade
sudo apt --purge autoremove
sudo apt --no-install-recommends install gnome-control-center gnome-session vim-gtk3
sudo apt install apache2 arc-theme black blender blueman conky-all cryptsetup deja-dup ffmpeg fonts-powerline gimp git git-ftp gnome-disk-utility gnupg2 gparted guvcview inkscape lmms mate-calc nodejs npm numix-icon-theme-circle pandoc php php-bcmath php-curl php-gd php-sqlite3 php-xml redshift spotify-client steam-installer ubuntustudio-fonts vim-airline vim-ale vim-ctrlp vim-gitgutter virtualbox virtualbox-ext-pack xarchiver xcalib xfce4-docklike-plugin xfce4-places-plugin zathura cm-super-x11-
sudo usermod -aG vboxusers $USER
sudo npm install -g n
sudo n latest
sudo npm install -g autoprefixer eslint npm postcss postcss-cli prettier pyright typescript
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo ln -rs config/vhosts.conf /etc/apache2/conf-available/vhosts.conf
sudo a2enconf vhosts
sudo sed -Ei 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /etc/php/*/*/php.ini
sudo mv /var/www/html/* ~/Public
sudo rmdir /var/www/html
sudo ln -s ~/Public /var/www/html
chmod o+rx ~
sudo service apache2 restart
sudo ln -rs config/71-synaptics.conf /usr/share/X11/xorg.conf.d/71-synaptics.conf
sudo ln -frs config/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
PWD_ESCAPED=$(sed 's/[&/\]/\\&/g' <<< $(pwd))
sed -E "s/\\\$PWD\b/$PWD_ESCAPED/g" config/power.service | sudo tee /lib/systemd/system/power.service
sudo systemctl enable power.service
sudo systemctl start power.service
rsync -Ir config/autostart config/guvcview2 config/gtk-3.0 config/Thunar config/xarchiver config/xfce4 config/zathura ~/.config
sed -Ei "s/\\\$USER\b/$USER/g" ~/.config/gtk-3.0/bookmarks
sudo update-locale LC_MESSAGES=fr_FR.UTF-8
LANGUAGE=fr_FR xdg-user-dirs-update --force
gsettings set org.blueman.plugins.powermanager auto-power-on false
gsettings set org.gnome.DejaDup backend google
gsettings set org.gnome.DejaDup include-list "['/media/$USER/ZERO/LiberKey/MyDocuments', '/media/$USER/ONE/LiberKey/MyDocuments']"
gsettings set org.gnome.DejaDup periodic true
gsettings set org.gnome.DejaDup.Google folder 'deja-dup'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding F1
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'xfce4-terminal --drop-down'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name Terminal
gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden true
xfconf-query -c keyboard-layout -p /Default/XkbDisable -n -t bool -s false
xfconf-query -c keyboard-layout -p /Default/XkbLayout -n -t string -s us,ru
xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -n -t string -s grp:win_space_toggle
xfconf-query -c keyboard-layout -p /Default/XkbVariant -n -t string -s mac,mac
xfconf-query -c thunar -p /last-location-bar -n -t string -s ThunarLocationButtons
xfconf-query -c thunar -p /last-show-hidden -n -t bool -s true
xfconf-query -c thunar -p /last-view -n -t string -s ThunarDetailsView
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t uint -s 0
xfconf-query -c xfce4-desktop -p /desktop-menu/show -n -t bool -s false
xfconf-query -c xfce4-desktop -p /windowlist-menu/show -n -t bool -s false
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioNext -n -t string -s 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPlay -n -t string -s 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPrev -n -t string -s 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt><Super>8' -n -t string -s 'xcalib -i -a'
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>e' -n -t string -s 'xfce4-terminal --maximize --hide-menubar --hide-scrollbar -x vim'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/F1 -n -t string -s 'xfce4-terminal --drop-down'
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_1' -n -t string -s tile_down_left_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_2' -n -t string -s tile_down_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_3' -n -t string -s tile_down_right_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_4' -n -t string -s tile_left_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_5' -n -t string -s fill_window_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_6' -n -t string -s tile_right_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_7' -n -t string -s tile_up_left_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_8' -n -t string -s tile_up_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Alt>KP_9' -n -t string -s tile_up_right_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift><Alt>Down' -n -t string -s move_window_down_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift><Alt>Left' -n -t string -s move_window_left_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift><Alt>Right' -n -t string -s move_window_right_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift><Alt>Up' -n -t string -s move_window_up_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F1' -n -t string -s move_window_workspace_1_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F10' -n -t string -s move_window_workspace_10_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F11' -n -t string -s move_window_workspace_11_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F12' -n -t string -s move_window_workspace_12_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F2' -n -t string -s move_window_workspace_2_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F3' -n -t string -s move_window_workspace_3_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F4' -n -t string -s move_window_workspace_4_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F5' -n -t string -s move_window_workspace_5_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F6' -n -t string -s move_window_workspace_6_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F7' -n -t string -s move_window_workspace_7_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F8' -n -t string -s move_window_workspace_8_key
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Shift>F9' -n -t string -s move_window_workspace_9_key
xfconf-query -c xfce4-panel -p / -r -R
xfconf-query -c xfce4-panel -p /configver -n -t uint -s 2
xfconf-query -c xfce4-panel -p /panels -n -t uint -s 1
xfconf-query -c xfce4-panel -p /panels/panel-0/background-rgba -n -t double -t double -t double -t double -s 0.219608 -s 0.235294 -s 0.290196 -s 0.6
xfconf-query -c xfce4-panel -p /panels/panel-0/background-style -n -t uint -s 1
xfconf-query -c xfce4-panel -p /panels/panel-0/disable-struts -n -t bool -s true
xfconf-query -c xfce4-panel -p /panels/panel-0/length -n -t uint -s 100
xfconf-query -c xfce4-panel -p /panels/panel-0/plugin-ids -n -t int -t int -t int -t int -t int -t int -t int -t int -t int -t int -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9 -s 10
xfconf-query -c xfce4-panel -p /panels/panel-0/position -n -t string -s 'p=6;x=0;y=0'
xfconf-query -c xfce4-panel -p /panels/panel-0/position-locked -n -t bool -s true
xfconf-query -c xfce4-panel -p /panels/panel-0/size -n -t uint -s 24
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -n -t string -s applicationsmenu
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -n -t string -s go-down-symbolic
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-title -n -t string -s ' Applications '
xfconf-query -c xfce4-panel -p /plugins/plugin-2 -n -t string -s places
xfconf-query -c xfce4-panel -p /plugins/plugin-2/button-label -n -t string -s ' Emplacements '
xfconf-query -c xfce4-panel -p /plugins/plugin-2/show-button-type -n -t uint -s 1
xfconf-query -c xfce4-panel -p /plugins/plugin-2/show-recent -n -t bool -s false
xfconf-query -c xfce4-panel -p /plugins/plugin-3 -n -t string -s docklike
xfconf-query -c xfce4-panel -p /plugins/plugin-4 -n -t string -s separator
xfconf-query -c xfce4-panel -p /plugins/plugin-4/expand -n -t bool -s true
xfconf-query -c xfce4-panel -p /plugins/plugin-4/style -n -t uint -s 0
xfconf-query -c xfce4-panel -p /plugins/plugin-5 -n -t string -s systray
xfconf-query -c xfce4-panel -p /plugins/plugin-6 -n -t string -s notification-plugin
xfconf-query -c xfce4-panel -p /plugins/plugin-7 -n -t string -s power-manager-plugin
xfconf-query -c xfce4-panel -p /plugins/plugin-8 -n -t string -s pulseaudio
xfconf-query -c xfce4-panel -p /plugins/plugin-9 -n -t string -s clock
xfconf-query -c xfce4-panel -p /plugins/plugin-9/digital-format -n -t string -s '%_H:%M '
xfconf-query -c xfce4-panel -p /plugins/plugin-10 -n -t string -s pager
xfconf-query -c xfce4-panel -p /plugins/plugin-10/rows -n -t uint -s 2
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-battery -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-off -n -t uint -s 5
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-battery-off -n -t uint -s 5
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-battery-sleep -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/general-notification -n -t bool -s true
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-battery -n -t uint -s 15
xfconf-query -c xfce4-screensaver -p /saver/enabled -n -t bool -s false
xfconf-query -c xfce4-screensaver -p /saver/idle-activation/enabled -n -t bool -s false
xfconf-query -c xfce4-session -p /general/SaveOnExit -n -t bool -s false
xfconf-query -c xfwm4 -p /general/button_layout -n -t string -s 'CMH|O'
xfconf-query -c xfwm4 -p /general/frame_opacity -n -t int -s 60
xfconf-query -c xfwm4 -p /general/mousewheel_rollup -n -t bool -s true
xfconf-query -c xfwm4 -p /general/popup_opacity -n -t int -s 80
xfconf-query -c xfwm4 -p /general/raise_with_any_button -n -t bool -s false
xfconf-query -c xfwm4 -p /general/scroll_workspaces -n -t bool -s false
xfconf-query -c xfwm4 -p /general/show_dock_shadow -n -t bool -s false
xfconf-query -c xfwm4 -p /general/show_popup_shadow -n -t bool -s true
xfconf-query -c xfwm4 -p /general/snap_to_windows -n -t bool -s true
xfconf-query -c xfwm4 -p /general/theme -n -t string -s Arc-Dark
xfconf-query -c xfwm4 -p /general/title_font -n -t string -s 'Neuropol 9'
xfconf-query -c xfwm4 -p /general/workspace_count -n -t int -s 4
xfconf-query -c xfwm4 -p /general/wrap_cycle -n -t bool -s false
xfconf-query -c xfwm4 -p /general/wrap_layout -n -t bool -s false
xfconf-query -c xfwm4 -p /general/wrap_windows -n -t bool -s false
xfconf-query -c xsettings -p /Gtk/ButtonImages -n -t bool -s false
xfconf-query -c xsettings -p /Gtk/CursorThemeName -n -t string -s DMZ-Black
xfconf-query -c xsettings -p /Gtk/DecorationLayout -n -t string -s close,maximize,minimize:menu
xfconf-query -c xsettings -p /Gtk/FontName -n -t string -s 'Roboto 10'
xfconf-query -c xsettings -p /Gtk/MenuImages -n -t bool -s false
xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s Numix-Circle
xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s Arc-Dark
xfce4-panel --restart
ssh-keygen -C deeptoaster@gmail.com -t ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
git config --global commit.gpgSign true
git config --global core.excludesFile ~/.gitignore
git config --global diff.tool vimdiff
git config --global gpg.format ssh
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
git config --global pull.rebase false
git config --global user.email deeptoaster@gmail.com
git config --global user.name 'Deep Toaster'
git config --global user.signingkey ~/.ssh/id_ed25519.pub
touch ~/.ssh/allowed_signers
ln -rs config/bash_aliases ~/.bash_aliases
ln -rs config/face ~/.face
ln -rs config/gitignore ~/.gitignore
ln -rs config/pam_environment ~/.pam_environment
ln -rs config/vimrc ~/.vimrc
ln -rs conky-rings/conkyrc ~/.conkyrc
mkdir -p ~/.lua/scripts
ln -rs conky-rings/rings.lua ~/.lua/scripts/rings.lua
git clone https://github.com/Xuyuanp/nerdtree-git-plugin ~/.vim/pack/foo/start/nerdtree-git-plugin
git clone https://github.com/preservim/nerdtree ~/.vim/pack/foo/start/nerdtree
git clone https://github.com/tiagofumo/vim-nerdtree-syntax-highlight ~/.vim/pack/foo/start/vim-nerdtree-syntax-highlight
git clone https://github.com/tpope/vim-obsession ~/.vim/pack/foo/start/vim-obsession
mkdir ~/.vim/colors
wget -O ~/.vim/colors/monokai.vim https://raw.githubusercontent.com/ErichDonGubler/vim-sublime-monokai/master/colors/sublimemonokai.vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 50
sudo update-alternatives --remove editor /usr/bin/vim.gtk3
sudo update-alternatives --set x-cursor-theme /usr/share/icons/DMZ-Black/cursor.theme
echo 'set editing-mode vi' > ~/.inputrc
echo -e "0 0 * * * $(pwd)/backdrops.py\n0 * * * * $(pwd)/power.sh\n" | crontab -
wget -O fonts-main.tar.gz https://github.com/google/fonts/archive/master.tar.gz
tar -xzf fonts-main.tar.gz
sudo mkdir -p /usr/share/fonts/truetype/google-fonts /usr/share/fonts/truetype/fira-code
find fonts-main -name "*.ttf" -exec sudo install -m644 {} /usr/share/fonts/truetype/google-fonts \;
rm -fr fonts-main fonts-main.tar.gz
curl https://api.github.com/repos/tonsky/FiraCode/releases/latest | grep \"browser_download_url\" | cut -d : -f 2,3 | tr -d \" | wget -i - -O fira-code.zip
unzip -d fira-code fira-code.zip
for type in fira-code/ttf/*; do
  sudo install -m644 $type /usr/share/fonts/truetype/fira-code
done
rm -fr fira-code fira-code.zip
fc-cache -f
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
sudo perl install-tl-*/install-tl --no-interaction
rm -fr install-tl-*
