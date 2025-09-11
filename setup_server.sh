#!/bin/bash
set -ex
DOCUMENT_ROOT=/var/www/html
FONT_ROOT=/usr/share/fonts/truetype
sudo apt update
sudo apt purge vim-tiny
sudo apt dist-upgrade
sudo apt --purge autoremove
sudo apt install apache2 black doxygen git-ftp inotify-tools npm pandoc php php-bcmath php-curl php-gd php-sqlite3 php-xml python3-pip python3-venv
sudo npm install -g n
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo ln -fs $(pwd)/config/vhosts.conf /etc/apache2/conf-available/vhosts.conf
sudo a2enconf vhosts
sudo sed -Ei'' -e 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /etc/php/*/*/php.ini
rsync -Ir config/nvim ~/.config
sudo update-locale LC_MESSAGES=fr_FR.UTF-8
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 50
(echo 'paths:'; echo "  - $HOME/latexindent.yaml") > ~/indentconfig.yaml
echo 'set editing-mode vi' > ~/.inputrc
source setup_common
