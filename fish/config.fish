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

function aws-ssh
    # Set the AWS profiles and corresponding private key paths
    set -l aws_profiles "default us"
    set -l private_key_paths "/Users/janmajayamall/desktop/aws/mac.pem /Users/janmajayamall/desktop/aws/mac-us.pem"

    echo > ~/.ssh/config

    # Split the AWS profiles and private key paths into arrays
    set -l aws_profile_arr (string split " " $aws_profiles)
    set -l private_key_arr (string split " " $private_key_paths)

    # Get the instance IDs and tag names using a specific tag, e.g., "Environment: production"
    for i in (seq (count $aws_profile_arr))
        set -l profile $aws_profile_arr[$i]
        set -l private_key_path $private_key_arr[$i]

        set -l instance_data (aws ec2 describe-instances --query "Reservations[].Instances[].{InstanceId: InstanceId, TagName: Tags[?Key=='Name'].Value | [0]}" --output json --profile $profile)

        # Loop through each instance
        for data in (echo $instance_data | jq -c '.[]')
            # Extract instance ID and tag name
            set -l id (echo $data | jq -r '.InstanceId')
            set -l tag_name (echo $data | jq -r '.TagName')

            # Skip if the ID or tag name is empty
            if test -z $id -o -z $tag_name
                continue
            end

            # Get the public DNS name for the instance
            set -l dns_name (aws ec2 describe-instances --instance-ids $id --query "Reservations[].Instances[].PublicDnsName" --output json --profile $profile | jq -r '.[]')

            # Skip if the DNS name is empty
            if test -z $dns_name
                continue
            end

            # Output the configuration to .ssh/config file
            echo "Host $tag_name" >> ~/.ssh/config
            echo "  Hostname $dns_name" >> ~/.ssh/config
            echo "  User ubuntu" >> ~/.ssh/config
            echo "  IdentityFile $private_key_path" >> ~/.ssh/config
            echo "" >> ~/.ssh/config
        end
    end
end
