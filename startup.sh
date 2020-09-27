sudo apt-get update

echo 'installing curl' 
sudo apt install curl -y

echo 'installing git' 
sudo apt install git -y

echo "What name do you want to use in GIT user.name?"
echo "For example, mine will be \"Lara Ludwig\""
read git_config_user_name
git config --global user.name "$git_config_user_name"
clear 

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"laraludwig18@gmail.com\""
read git_config_user_email
git config --global user.email $git_config_user_email
clear

echo "Generating a SSH Key"
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'installing vim'
sudo apt install vim -y
clear

echo 'installing code'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders

echo 'installing extensions'
code --install-extension Shan.code-settings-sync

echo 'installing zsh'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo 'installing tool to handle clipboard via CLI'
sudo apt-get install xclip -y

export alias pbcopy='xclip -selection clipboard'
export alias pbpaste='xclip -selection clipboard -o'
source ~/.zshrc

echo 'installing nvm' 
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.36.0/install.sh | bash)"

export NVM_DIR="$HOME/.nvm" && (
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

echo '\nexport PATH=/usr/local/share/npm/bin:$PATH\n'

echo '\nexport NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>  ~/.zshrc

source ~/.zshrc
nvm install --lts
nvm current

echo 'installing theme'
sudo apt-get install dconf-cli
git clone https://github.com/dracula/gnome-terminal && cd gnome-terminal && ./install.sh
sudo apt install fonts-firacode fontconfig
sudo git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
sudo ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo '\nSPACESHIP_PROMPT_ORDER=(\n user\n dir\n host\n git\n hg\n exec_time\n line_sep\n vi_mode\n jobs\n exit_code\n char\n)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SUFFIX=" "' >>  ~/.zshrc

echo 'installing zsh plugins' 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

echo 'installing docker' 
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER

echo 'installing docker-compose' 
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'installing aws-cli' 
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

echo 'installing dbeaver'
wget -c https://dbeaver.io/files/7.2.1/dbeaver-ce_7.2.1_amd64.deb
sudo dpkg -i dbeaver-ce_7.2.1_amd64.deb
sudo apt-get install -f

echo 'installing MongoDB compass'
wget -c https://downloads.mongodb.com/compass/mongodb-compass_1.22.1_amd64.deb
sudo dpkg -i mongodb-compass_1.22.1_amd64.deb
sudo apt-get install -f

echo 'installing Insomnia'
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -
sudo apt-get update && sudo apt-get install insomnia

echo 'installing Yarn'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install --no-install-recommends yarn
