#!/bin/bash

# Fetch submodules
git submodule update --init --recursive

system_kind=""

# Setup script for Dotfiles
function install_arch {
    sudo pacman -S \
        curl git zsh python vim neovim tmux bat fzf fasd fd exa unzip \
        lsd github-cli git-delta lazygit openssh ranger the_silver_searcher \
        thefuck xclip broot ncdu htop broot xplr ripgrep powerline \
        kitty libnotify autorandr cmus ttf-firacode-nerd
}

function install_debian {
    sudo apt install \
        curl git zsh vim neovim tmux bat fzf fasd python exa gh ripgrep htop \
        silversearcher-ag fd-find unzip thefuck xclip ncdu ranger powerline \
        kitty libnotify-bin autorandr cmus
    sudo ln -sfnv /usr/bin/fdfind /usr/bin/fd
    sudo ln -sfnv /usr/bin/batcat /usr/bin/bat
}

function install_mac {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install asdf bat exa fasd fd fzf gh gotop lazygit lsd ncdu neofetch \
        neovim pastel ripgrep skhd tmux wget yabai iterm2 maccy stats
}

function install_linux {
    # Identify the Linux distribution
    if [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        if [[ "$ID" == "arch" ]]; then
            system_kind="Linux_Arch"
            install_arch
        elif [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
            system_kind="Linux_Debian"
            install_debian
            if [[ "$ID" == "ubuntu" ]]; then
                system_kind="Linux_Debian_Ubuntu"
            fi
            if [[ "$ID" == "linuxmint" ]]; then
                system_kind="Linux_Debian_Mint"
            fi
            if [[ "$ID" == "popos" ]]; then
                system_kind="Linux_Debian_Pop"
            fi
        elif [[ "$ID" == "fedora" ]]; then
            system_kind="Linux_Fedora"
        elif [[ "$ID" == "centos" ]]; then
            system_kind="Linux_CentOS"
        fi
    else
        system_kind="Linux_Unknown"
    fi
}

function install_packages {
    if [[ "$(uname)" == "Linux" ]]; then
        system_kind="Linux"
        install_linux
    elif [[ "$(uname)" == "Darwin" ]]; then
        system_kind="Mac"
        install_mac
    # Check if the system is running Windows
    elif [[ "$(uname -s)" =~ "CYGWIN" ]]; then
        system_kind="Windows_Cygwin"
    elif [[ "$(uname -r)" =~ "Microsoft" ]]; then
        system_kind="Windows_WSL"
    else
        system_kind="Unknown"
    fi
    echo "Installing packages for $system_kind"
}

function install_oh_my_zsh {
    echo -e "\u001b[7m Installing oh-my-zsh...\u001b[0m"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

function install_zsh_plugins {
    echo -e "\u001b[7m Installing zsh plugins...\u001b[0m"
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    git clone https://github.com/marlonrichert/zsh-autocomplete ~/.oh-my-zsh/custom/plugins/zsh-autocomplete
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/clarketm/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/z-shell/F-Sy-H.git ~/.oh-my-zsh/custom/plugins/F-Sy-H
    git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips
    git clone https://github.com/unixorn/git-extra-commands.git ~/.oh-my-zsh/custom/plugins/git-extra-commands
    git clone https://github.com/Aloxaf/fzf-tab.git ~/.oh-my-zsh/custom/plugins/fzf-tab
    git clone https://github.com/hlissner/zsh-autopair ~/.oh-my-zsh/custom/plugins/zsh-autopair
    git clone https://github.com/MichaelAquilina/zsh-auto-notify.git ~/.oh-my-zsh/custom/plugins/auto-notify
}

function install_vim_plugins {
    echo -e "\u001b[7m Installing plugin manager \u001b[0m"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo -e "\u001b[7m Installing plugins for vim and nvim... \u001b[0m"
    vim +PlugUpdate +qall
    pip install neovim
    nvim -c UpdateRemotePlugins
}

function install_tmux_plugins {
    echo -e "\u001b[7m Installing tmux plugins... \u001b[0m"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux start-server
    tmux new-session -d
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    tmux kill-server
}

function install_extras {
    install_oh_my_zsh
    install_zsh_plugins
    install_vim_plugins
    install_tmux_plugins
}

function backup_configs {
    echo -e "\u001b[33;1m Backing up existing files... \u001b[0m"
    mv -iv ~/.config/autorandr ~/.config/autorandr.old
    mv -iv ~/.config/awesome/ ~/.config/awesome.old
    mv -iv ~/.config/bat/config ~/.config/bat/config.old
    mv -iv ~/.config/broot/conf.toml ~/.config/broot/conf.toml.old
    mv -iv ~/.config/cmus/darkwind.theme ~/.config/cmus/darkwind.theme.old
    mv -iv ~/.config/delta ~/.config/delta.old
    mv -iv ~/.config/fish/ ~/.config/fish.old
    mv -iv ~/.config/fontconfig/ ~/.config/fontconfig.old
    mv -iv ~/.config/htop ~/.config/htop.old
    mv -iv ~/.config/i3 ~/.config/i3.old
    mv -iv ~/.config/i3status ~/.config/i3status.old
    mv -iv ~/.config/kitty ~/.config/kitty.old
    mv -iv ~/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf.old
    mv -iv ~/.config/nvim ~/.config/nvim.old
    mv -iv ~/.config/ranger ~/.config/ranger.old
    mv -iv ~/.config/rofi ~/.config/rofi.old
    mv -iv ~/.config/shell ~/.config/shell.old
    mv -iv ~/.config/sysinfo.conkyrc ~/.config/sysinfo.conkyrc.old
    mv -iv ~/.config/xplr ~/.config/xplr.old
    mv -iv ~/.asdfrc ~/.asdfrc.old
    mv -iv ~/.bashrc ~/.bashrc.old
    mv -iv ~/.dircolors ~/.dircolors.old
    mv -iv ~/.dmenurc ~/.dmenurc.old
    mv -iv ~/.gitconfig ~/.gitconfig.old
    mv -iv ~/.gitignore.global ~/.gitignore.global.old
    mv -iv ~/.p10k.zsh ~/.p10k.zsh.old
    mv -iv ~/.prettierrc ~/.prettierrc.old
    mv -iv ~/.pryrc ~/.pryrc.old
    mv -iv ~/.pystartup ~/.pystartup.old
    mv -iv ~/.stylua.toml ~/.stylua.toml.old
    mv -iv ~/.tmux.conf ~/.tmux.conf.old
    mv -iv ~/.vimrc ~/.vimrc.old
    mv -iv ~/.Xresources ~/.Xresources.old
    mv -iv ~/.zshrc ~/.zshrc.old
    echo -e "\u001b[36;1m Remove backups with 'rm -ir ~/.*.old && rm -ir ~/.config/*.old'. \u001b[0m"
}

function setup_symlinks {
    echo -e "\u001b[7m Setting up symlinks... \u001b[0m"
    ln -sfnv "$PWD/.config/autorandr/" ~/.config/
    ln -sfnv "$PWD/.config/awesome/" ~/.config/
    ln -sfnv "$PWD/.config/bat/" ~/.config/
    ln -sfnv "$PWD/.config/broot/" ~/.config/
    ln -sfnv "$PWD/.config/cmus/" ~/.config/
    ln -sfnv "$PWD/.config/delta/" ~/.config/
    ln -sfnv "$PWD/.config/fish/" ~/.config/
    ln -sfnv "$PWD/.config/fontconfig/" ~/.config/
    ln -sfnv "$PWD/.config/htop/" ~/.config/
    ln -sfnv "$PWD/.config/i3" ~/.config/
    ln -sfnv "$PWD/.config/i3status" ~/.config/
    ln -sfnv "$PWD/.config/kitty" ~/.config/
    ln -sfnv "$PWD/.config/lazygit" ~/.config/
    ln -sfnv "$PWD/.config/libinput-gestures.conf" ~/.config/
    ln -sfnv "$PWD/.config/nvim" ~/.config/
    ln -sfnv "$PWD/.config/ranger/" ~/.config/
    ln -sfnv "$PWD/.config/rofi/" ~/.config/
    ln -sfnv "$PWD/.config/shell" ~/.config/
    ln -sfnv "$PWD/.config/sysinfo.conkyrc" ~/.config/
    ln -sfnv "$PWD/.config/xplr/" ~/.config/
    cp -ivr "$PWD/.local/share/konsole/" ~/.local/share/
    ln -sfnv "$PWD/.asdfrc" ~/
    ln -sfnv "$PWD/.bashrc" ~/
    ln -sfnv "$PWD/.dircolors" ~/
    ln -sfnv "$PWD/.dmenurc" ~/
    ln -sfnv "$PWD/.gitconfig" ~/
    ln -sfnv "$PWD/.gitignore.global" ~/
    ln -sfnv "$PWD/.p10k.zsh" ~/
    ln -sfnv "$PWD/.prettierrc" ~/
    ln -sfnv "$PWD/.pryrc" ~/
    ln -sfnv "$PWD/.pystartup" ~/
    ln -sfnv "$PWD/.stylua.toml" ~/
    ln -sfnv "$PWD/.tmux.conf" ~/
    ln -sfnv "$PWD/.vimrc" ~/
    ln -sfnv "$PWD/.Xresources" ~/
    ln -sfnv "$PWD/.zshrc" ~/
}

function distro_tweaks {
    echo -e "\u001b[7m Distro specific tweaks... \u001b[0m"
    bash "$PWD"/scripts/local_distro.sh
}

function setup_dotfiles {
    echo -e "\u001b[7m Setting up Dotfiles... \u001b[0m"
    install_packages
    install_extras
    backup_configs
    setup_symlinks
    distro_tweaks
    echo -e "\u001b[7m Done! \u001b[0m"
}

if [ "$1" = "--all" ] || [ "$1" = "-a" ]; then
    setup_dotfiles
    exit 0
fi

if [ "$1" = "--install" ] || [ "$1" = "-i" ]; then
    install_packages
    install_extras
    exit 0
fi

if [ "$1" = "--symlinks" ] || [ "$1" = "-s" ]; then
    setup_symlinks
    exit 0
fi

# Menu TUI
echo -e "\u001b[32;1m Setting up Dotfiles...\u001b[0m"

echo -e " \u001b[37;1m\u001b[4mSelect an option:\u001b[0m"
echo -e "  \u001b[34;1m (0) Setup Everything \u001b[0m"
echo -e "  \u001b[34;1m (1) Install Packages \u001b[0m"
echo -e "  \u001b[34;1m (2) Install Extras \u001b[0m"
echo -e "  \u001b[34;1m (3) Backup Configs \u001b[0m"
echo -e "  \u001b[34;1m (4) Setup Symlinks \u001b[0m"
echo -e "  \u001b[34;1m (5) Distro Tweaks \u001b[0m"
echo -e "  \u001b[31;1m (*) Anything else to exit \u001b[0m"

echo -en "\u001b[32;1m ==> \u001b[0m"

read -r option

case $option in

"0")
    setup_dotfiles
    ;;

"1")
    install_packages
    ;;

"2")
    install_extras
    ;;

"3")
    backup_configs
    ;;

"4")
    setup_symlinks
    ;;

"5")
    distro_tweaks
    ;;

*)
    echo -e "\u001b[31;1m Invalid option entered, Bye! \u001b[0m"
    exit 0
    ;;
esac

exit 0
