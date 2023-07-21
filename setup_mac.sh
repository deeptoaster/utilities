#!/bin/zsh
set -ex
/bin/bash -c "$(curl -fLS https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install firefox n php spotify texlive
sudo n latest
sudo npm install -g autoprefixer eslint eslint-config-airbnb npm postcss postcss-cli prettier pyright typescript
sudo sed -Ei.bak -e 's/^#(LoadModule (rewrite|vhost_alias)_module )/\1/' /etc/apache2/httpd.conf
(echo 'LoadModule php_module /opt/homebrew/opt/php/lib/httpd/modules/libphp.so woot'; echo; echo '<FilesMatch \.php$>'; echo '    SetHandler application/x-httpd-php'; echo '</FilesMatch>') | sudo tee -a /etc/apache2/httpd.conf
sudo cp -f $(pwd)/config/vhosts_mac.conf /etc/apache2/other/vhosts.conf
sudo sed -Ei'' -e 's/^(display_errors|short_open_tag) = Off$/\1 = On/' /opt/homebrew/etc/php/*/php.ini
sudo mv /Library/WebServer/Documents/* ~/Public
sudo rmdir /Library/WebServer/Documents
sudo ln -fns ~/Public /Library/WebServer/Documents
chmod o+rx ~ ~/Documents
sudo apachectl restart
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.Finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.Finder ShowPathbar -bool true
defaults write com.apple.Finder _FXSortFoldersFirst -bool true
/usr/libexec/PlistBuddy -c 'Set :AppleSymbolicHotKeys:21:enabled true' ~/Library/Preferences/com.apple.symbolichotkeys.plist
defaults write com.apple.universalaccess closeViewPanningMode -integer 0
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
open config/Vim.terminal
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
ln -fs $(pwd)/config/bash_aliases ~/.bash_aliases
ln -fs $(pwd)/config/eslintrc.json ~/.eslintrc.json
ln -fs $(pwd)/config/face ~/.face
ln -fs $(pwd)/config/gitignore ~/.gitignore
ln -fs $(pwd)/config/pam_environment ~/.pam_environment
ln -fs $(pwd)/config/pyrightconfig.json ~/pyrightconfig.json
ln -fs $(pwd)/config/vimrc ~/.vimrc
ln -fs $(pwd)/config/zshenv ~/.zshenv
git clone https://github.com/dense-analysis/ale ~/.vim/pack/foo/opt/ale
git clone https://github.com/ctrlpvim/ctrlp.vim ~/.vim/pack/foo/opt/ctrlp
git clone https://github.com/Xuyuanp/nerdtree-git-plugin ~/.vim/pack/foo/opt/nerdtree-git-plugin
git clone https://github.com/preservim/nerdtree ~/.vim/pack/foo/opt/nerdtree
git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/foo/start/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/pack/foo/start/vim-airline-themes
git clone https://github.com/ryanoasis/vim-devicons ~/.vim/pack/foo/opt/vim-devicons
git clone https://github.com/tpope/vim-fugitive ~/.vim/pack/foo/start/vim-fugitive
git clone https://github.com/airblade/vim-gitgutter ~/.vim/pack/foo/start/vim-gitgutter
git clone https://github.com/tpope/vim-surround ~/.vim/pack/foo/opt/vim-surround
mkdir ~/.vim/colors
curl -fLo ~/.vim/colors/gruvbox.vim -S https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim
curl -fLo ~/.vim/colors/monokai.vim -S https://raw.githubusercontent.com/ErichDonGubler/vim-sublime-monokai/master/colors/sublimemonokai.vim
curl -fLo ~/.vim/colors/sierra.vim -S https://raw.githubusercontent.com/AlessandroYorba/Sierra/master/colors/sierra.vim
ln -fns $(pwd)/config/after ~/.vim/after
ln -fns $(pwd)/config/compiler ~/.vim/compiler
(echo "0 0 * * * $(pwd)/backdrops.py"; echo "0 * * * * $(pwd)/power.sh") | crontab -
curl -fLo fonts-main.tar.gz -S https://github.com/google/fonts/archive/master.tar.gz
tar -xzf fonts-main.tar.gz
sudo mkdir -p /Library/Fonts/google-fonts /Library/Fonts/fira-code
find fonts-main -name "*.ttf" -exec sudo install -m644 {} /Library/Fonts/google-fonts \;
rm -fr fonts-main fonts-main.tar.gz
for variant in Bold Light Medium Regular Retina SemiBold; do
  sudo curl -fLo /Library/Fonts/fira-code/FiraCodeNerdFont-$variant.ttf -S https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/$variant/FiraCodeNerdFont-$variant.ttf
done
fc-cache -f
