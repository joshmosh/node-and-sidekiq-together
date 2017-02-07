#!/bin/bash

echo "[Provisioning] Checking for nvm..."

if [ ! -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
  ) && . "$NVM_DIR/nvm.sh"

  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.bashrc
else
  echo "[Provisioning] Updating nvm..."

  (
    cd "$NVM_DIR"
    git fetch origin
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
  ) && . "$NVM_DIR/nvm.sh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export NODE_VERSION=6.9.5

if [ ! -d "$HOME/.nvm/versions/node/v$NODE_VERSION/bin/node" ]; then
  nvm install $NODE_VERSION

  nvm use $NODE_VERSION
  nvm alias default $NODE_VERSION
fi

echo "[Provisioning] Checking for rbenv..."
if [ ! -d "$HOME/.rbenv" ]; then
  echo "[Provisioning] No rbenv found. Installing..."

  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  git clone git://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset
  git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
else
  echo "[Provisioning] Updating rbenv and plugins..."

  cd ~/.rbenv
  git pull origin master

  cd ~/.rbenv/plugins/ruby-build
  git pull origin master

  cd ~/.rbenv/plugins/rbenv-gemset
  git pull origin master

  cd ~/.rbenv/plugins/rbenv-gem-rehash
  git pull origin master
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export RUBY_VERSION=2.4.0

if [ ! -d "$HOME/.rbenv/versions/$RUBY_VERSION" ]; then
  echo "[Provisioning] Installing Ruby..."

  rbenv install $RUBY_VERSION
  rbenv global $RUBY_VERSION

  gem install bundler
fi

echo "[Provisioning] Dependencies installed. Setting up project..."
cd /vagrant
bundle install
npm install

echo "[Provisioning] Done!"
