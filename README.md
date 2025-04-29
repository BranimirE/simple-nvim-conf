![sample](https://github.com/BranimirE/simple-nvim-conf/assets/4145502/de2df5ec-700f-4219-a55a-8e56a48713cc)

To make it run in Ubuntu:
```bash
#Install some dependencies
sudo apt update
sudo apt install git ripgrep build-essential wget curl unzip fzf

#Install neovim using bob package manager
wget https://github.com/MordechaiHadad/bob/releases/download/v4.0.3/bob-linux-x86_64.zip
unzip bob-linux-x86_64.zip
cd bob-linux-x86_64/
chmod +x bob
sudo mv bob /usr/local/bin/
cd ..
rm -rf bob-linux*
bob install latest
bob use latest
echo "PATH=\$PATH:~/.local/share/bob/nvim-bin" >> .bashrc

#Install NVM for nodejs (as a regular non-root user)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
npm install -g yarn

#Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -rf lazygit*

#Clone this repo in $HOME/.config/nvim
git clone git@github.com:BranimirE/simple-nvim-conf.git
ln -s "$(pwd)/simple-nvim-conf/" "$HOME/.config/nvim
```
