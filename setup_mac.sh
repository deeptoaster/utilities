#!/bin/zsh
set -ex
DOCUMENT_ROOT=/Library/WebServer/Documents
FONT_ROOT=/Library/Fonts
/bin/bash -c "$(curl -fLS https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install firefox n pandoc php spotify texlive
sudo sed -Ei.bak -e 's/^#(LoadModule (rewrite|vhost_alias)_module )/\1/' /etc/apache2/httpd.conf
(echo 'LoadModule php_module /opt/homebrew/opt/php/lib/httpd/modules/libphp.so woot'; echo; echo '<FilesMatch \.php$>'; echo '    SetHandler application/x-httpd-php'; echo '</FilesMatch>') | sudo tee -a /etc/apache2/httpd.conf
sudo cp -f $(pwd)/config/vhosts.conf /etc/apache2/other/vhosts.conf
sudo sed -Ei'' -e 's/\/var\/www\/html\b/\/Library\/Webserver\/Documents/' /etc/apache2/other/vhosts.conf
sudo sed -Ei'' -e 's/\/var\/www\b/\/Library\/Webserver/' /etc/apache2/other/vhosts.conf
sudo sed -Ei'' -e 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /opt/homebrew/etc/php/*/php.ini
rsync -Ir config/nvim ~/.config
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
/usr/libexec/PlistBuddy -c 'Set :AppleSymbolicHotKeys:21:enabled true' ~/Library/Preferences/com.apple.symbolichotkeys.plist
defaults write com.apple.universalaccess closeViewPanningMode -integer 0
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
open -a Terminal config/Vim.terminal
ln -fs $(pwd)/config/zshenv ~/.zshenv
git clone https://github.com/dense-analysis/ale ~/.vim/pack/foo/opt/ale
git clone https://github.com/ctrlpvim/ctrlp.vim ~/.vim/pack/foo/opt/ctrlp
git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/foo/start/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/pack/foo/start/vim-airline-themes
git clone https://github.com/tpope/vim-fugitive ~/.vim/pack/foo/start/vim-fugitive
git clone https://github.com/airblade/vim-gitgutter ~/.vim/pack/foo/start/vim-gitgutter
source setup_common
