#!/bin/bash

set -e

VERSION="1.9.3"

shell_profile="bashrc"

DFILE="go$VERSION.linux-amd64.tar.gz"

if [ -d "$HOME/.go" ] || [ -d "$HOME/go" ]; then
    source /var/lib/buildkite-agent/.bashrc
    echo "The 'go' or '.go' directories already exist. Exiting."
    exit 0
fi

wget https://storage.googleapis.com/golang/$DFILE -O /tmp/go.tar.gz

if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi

echo "Extracting File..."
tar -C "$HOME" -xzf /tmp/go.tar.gz
mv "$HOME/go" "$HOME/.go"
touch "$HOME/.${shell_profile}"
{
    echo '# GoLang'
    echo 'export GOROOT=$HOME/.go'
    echo 'export PATH=$PATH:$GOROOT/bin'
    echo 'export GOPATH=$HOME/go'
    echo 'export PATH=$PATH:$GOPATH/bin'
} >> "$HOME/.${shell_profile}"

mkdir -p $HOME/go/{src,pkg,bin}
echo -e "\nGo $VERSION was installed.\nMake sure to relogin into your shell or run:"
echo -e "\n\tsource $HOME/.${shell_profile}\n\nto update your environment variables."
echo "Tip: Opening a new terminal window usually just works. :)"
rm -f /tmp/go.tar.gz
source /var/lib/buildkite-agent/.bashrc



