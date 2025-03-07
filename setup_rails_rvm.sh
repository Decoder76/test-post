#!/bin/bash
# Termux Rails Development Environment Setup with RVM
# This script updates Termux, installs necessary dependencies,
# sets up RVM (Ruby Version Manager) for managing multiple Ruby versions,
# installs multiple Ruby versions, sets a default, installs Bundler and Rails,
# and installs Node.js, Yarn, and SQLite.
# It also includes fixes for common issues such as missing linker (ld).

# Stop the script if any command fails
set -e

echo "🚀 Starting Rails development setup with RVM for Termux..."

# 1️⃣ Update & Upgrade Termux Packages
echo "🔄 Updating Termux packages..."
pkg update -y && pkg upgrade -y

# 2️⃣ Install Essential Dependencies
echo "📦 Installing essential development tools and dependencies..."
pkg install -y clang make binutils openssl libffi libxml2 libxslt readline ncurses gnupg curl git nodejs yarn sqlite

# Ensure the linker (ld) is installed (binutils should provide this)
if ! command -v ld &> /dev/null; then
    echo "⚠️ ld not found, installing binutils..."
    pkg install -y binutils
fi

# Create symlink for sqlite3 library if needed
if [ ! -f "$PREFIX/lib/libsqlite3.so.0" ]; then
    ln -sf $PREFIX/lib/libsqlite3.so $PREFIX/lib/libsqlite3.so.0
fi

# 3️⃣ Install RVM (Ruby Version Manager)
echo "💎 Installing RVM (Ruby Version Manager)..."
curl -sSL https://rvm.io/mpapis.asc | gpg --import -   # Import GPG keys
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -L https://get.rvm.io | bash -s stable

# 4️⃣ Configure Shell to Load RVM Automatically
echo "🔧 Configuring RVM to load in your shell..."
if [ -f "$HOME/.bashrc" ]; then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> $HOME/.bashrc
fi
if [ -f "$HOME/.zshrc" ]; then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> $HOME/.zshrc
fi
source "$HOME/.rvm/scripts/rvm"

# 5️⃣ Install Multiple Ruby Versions
echo "💎 Installing Ruby versions with RVM..."
rvm install 3.2.2  # Latest stable version (change if needed)
rvm install 3.1.4  # Optional: another recent version
rvm install 2.7.6  # Optional: older version for compatibility

# 6️⃣ Set the Default Ruby Version
echo "🛠️ Setting Ruby 3.2.2 as the default version..."
rvm use 3.2.2 --default

# 7️⃣ Install Bundler & Rails
echo "📦 Installing Bundler & Rails..."
gem install bundler
gem install rails --no-document

# 8️⃣ Verify Installations
echo "✅ Verifying installation..."
echo "RVM version: $(rvm -v)"
echo "Installed Ruby versions: $(rvm list)"
echo "Current Ruby version: $(ruby -v)"
echo "Rails version: $(rails -v)"
echo "Bundler version: $(bundler -v)"
echo "Node.js version: $(node -v)"
echo "Yarn version: $(yarn -v)"
echo "SQLite version: $(sqlite3 --version)"

echo "🎉 Rails development environment with RVM is ready in Termux!"
