# set paths
set PATH $PATH $HOME/.cargo/bin
switch (uname)
    case Darwin
        set PATH $PATH /opt/homebrew/bin
    case Linux
    case * 
end


abbr cal 'cal -y'

if command -v exa &> /dev/null
    abbr -a l exa
    abbr -a ls exa
    abbr -a ll 'exa -l'
    abbr -a lll 'exa -la'
    abbr -a llll 'exa -l -T -L=2'
else 
    abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.gcloud/path.fish.inc" ]; . "$HOME/.gcloud/path.fish.inc"; end

function rubbish
    openssl rand -base64 20 | pbcopy
end

function gc-ssh
    gcloud compute config-ssh --remove
    gcloud compute config-ssh
end

function update_plugins
    fisher install PatrickF1/fzf.fish
end

function dh -d "Fuzzily delete entries from your history"
  history | fzf | read -l item; and history delete --prefix "$item"
end