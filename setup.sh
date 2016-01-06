#!/bin/bash
sudo apt-get --auto-remove purge file-roller gigolo gmusicbrowser gnome-mines gnome-sudoku libreoffice-* mousepad mugshot parole ristretto software-center thunar-volman thunderbird xfce4-notes xfce4-whiskermenu-plugin
sudo add-apt-repository ppa:dockbar-main/ppa
sudo add-apt-repository ppa:numix/ppa
sudo bash -c 'echo deb http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_15.10 ./ > /etc/apt/sources.list.d/jgeboski.list'
wget -O- https://jgeboski.github.io/obs.key | sudo apt-key add -
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install abiword apache2 audacious blender cryptsetup deja-dup geany geany-plugin-markdown geany-plugins gimp git gnome-disk-utility gnome-power-manager gnumeric gnupg2 gparted guvcview lmms mysql-server numix-icon-theme-circle php5 php5-curl php5-gd php5-mcrypt php5-mysql purple-facebook ubuntustudio-font-meta wine xarchiver xcalib xfce4-dockbarx-plugin xfce4-sensors-plugin
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
sudo sed -ri 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /etc/php5/apache2/php.ini
sudo mysql_install_db
sudo service apache2 restart
wget -O ~/.config/geany/colorschemes/monokai.conf https://raw.githubusercontent.com/codebrainz/geany-themes/master/colorschemes/monokai.conf
gsettings set org.blueman.plugins.powermanager auto-power-on false
gsettings set org.gnome.gnumeric.core.gui.toolbars object-visible false
gsettings set org.gnome.gnumeric.core.gui.toolbars standard-visible false
