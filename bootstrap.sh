#!/bin/bash

# install fish shell 
if ! command -v fish &> /dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Installing fish on Macos"
        brew install fish
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Installing fish on Lunix"
        sudo apt-get update
        sudo apt-get install fish -y
    else
        echo "Stranger OS. Can't install fish!"
    fi
fi

# install fzf
if [[ ! -f $HOME/.fzf/bin/fzf ]]; then
    echo "Installing fzf"
    git clone https://github.com/junegunn/fzf.git $HOME/.fzf
    yes | $HOME/.fzf/install
fi

# install fisher (fish shell plugin manager)
if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    echo "Installing fisher"
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
fi


# install rust
if [[ ! -d $HOME/.rustup ]]; then
    echo "Installing rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# install imp crates
for crate in exa bat tealdeer fd-find ripgrep
do 
    echo "Installing $crate"
    $HOME/.cargo/bin/cargo install $crate
done

# Install nvim related things
sudo apt install build-essential libreadline-dev unzip
sudo apt install lua5.4 liblua5.4-dev luarocks

# link
./link.sh
