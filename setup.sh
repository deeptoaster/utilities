#!/bin/bash
sudo add-apt-repository ppa:dockbar-main/ppa
sudo add-apt-repository ppa:numix/ppa
sudo bash -c 'echo "deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /" >> /etc/apt/sources.list.d/arc-theme.list'
sudo apt update
sudo apt purge evince file-roller gigolo gmusicbrowser gnome-mines gnome-sudoku mousepad mugshot parole software-center thunar-volman
sudo apt --purge autoremove
sudo apt dist-upgrade
sudo apt install apache2 arc-theme audacious blender cryptsetup deja-dup geany geany-plugin-markdown geany-plugins gimp git gnome-disk-utility gnome-power-manager gnumeric gnupg2 gparted guvcview inkscape lmms numix-icon-theme-circle php php-curl php-gd php-mcrypt ubuntustudio-font-meta xarchiver xcalib xfce4-dockbarx-plugin xfce4-sensors-plugin zathura
sudo sed -i 's/^OnlyShowIn=/#OnlyShowIn=/' /usr/share/applications/gnome-power-statistics.desktop
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo bash -c 'cat > /etc/apache2/conf-available/vhosts.conf <<EOF
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
EOF'
sudo a2enconf vhosts
sudo sed -ri 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /etc/php/7.0/apache2/php.ini
sudo service apache2 restart
gsettings set org.blueman.plugins.powermanager auto-power-on false
xfconf-query -c thunar -p /last-location-bar -n -t string -s ThunarLocationButtons
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/F1 -n -t string -s 'xfce4-terminal --drop-down'
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt><Super>8' -n -t string -s 'xcalib -i -a'
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>e' -n -t string -s geany
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioNext -n -t string -s 'audacious -f'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPlay -n -t string -s 'audacious -t'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioPrev -n -t string -s 'audacious -r'
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86Music -n -t string -s audacious
wget -O ~/.config/geany/colorschemes/monokai.conf https://raw.githubusercontent.com/codebrainz/geany-themes/master/colorschemes/monokai.conf
cat > .config/geany/filedefs/filetypes.latex <<EOF
[build-menu]
FT_00_LB=LaTeX -> _DVI
FT_00_CM=latex --file-line-error-style "%f" && rm "%e.aux" "%e.log" "%e.out"
FT_00_WD=
FT_01_LB=LaTeX -> _PDF
FT_01_CM=pdflatex --file-line-error-style "%f" && rm "%e.aux" "%e.log" "%e.out"
FT_01_WD=
EX_00_LB=V_iew PDF File
EX_00_CM=zathura "%e.pdf"
EX_00_WD=
EX_01_LB=_View DVI File
EX_01_CM=zathura "%e.dvi"
EX_01_WD=
EOF
wget https://raw.githubusercontent.com/hotice/webupd8/master/install-google-fonts
chmod +x install-google-fonts
./install-google-fonts
rm install-google-fonts
echo "set editing-mode vi" > ~/.inputrc
sudo update-alternatives --set editor /usr/bin/vim.tiny
