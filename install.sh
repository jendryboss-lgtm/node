#!/usr/bin/env bash

# Node.js Installation Script
# This script automates the installation of Node.js from source
# Usage: curl -fsSL https://claude.ai/install.sh | bash

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS and architecture
detect_platform() {
    OS="$(uname -s)"
    ARCH="$(uname -m)"

    case "$OS" in
        Linux*)     OS_TYPE="linux";;
        Darwin*)    OS_TYPE="darwin";;
        CYGWIN*)    OS_TYPE="windows";;
        MINGW*)     OS_TYPE="windows";;
        *)          OS_TYPE="unknown";;
    esac

    case "$ARCH" in
        x86_64)     ARCH_TYPE="x64";;
        aarch64)    ARCH_TYPE="arm64";;
        armv7l)     ARCH_TYPE="armv7l";;
        *)          ARCH_TYPE="$ARCH";;
    esac

    log_info "Detected platform: $OS_TYPE ($ARCH_TYPE)"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        IS_ROOT=true
        INSTALL_PREFIX="/usr/local"
    else
        IS_ROOT=false
        INSTALL_PREFIX="$HOME/.local"
    fi
    log_info "Installation prefix: $INSTALL_PREFIX"
}

# Check for required dependencies
check_dependencies() {
    log_info "Checking for required dependencies..."

    local missing_deps=()

    # Common dependencies
    for cmd in python3 make gcc g++; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Please install the following packages:"

        case "$OS_TYPE" in
            linux)
                if command -v apt-get &> /dev/null; then
                    echo "  sudo apt-get install -y python3 make gcc g++"
                elif command -v yum &> /dev/null; then
                    echo "  sudo yum install -y python3 make gcc gcc-c++"
                elif command -v dnf &> /dev/null; then
                    echo "  sudo dnf install -y python3 make gcc gcc-c++"
                fi
                ;;
            darwin)
                echo "  xcode-select --install"
                echo "  brew install python3"
                ;;
        esac

        exit 1
    fi

    log_info "All dependencies satisfied"
}

# Download or use existing Node.js source
get_source() {
    if [ -f "configure" ] && [ -f "Makefile" ]; then
        log_info "Using existing Node.js source directory"
        SOURCE_DIR="$(pwd)"
    else
        log_info "Downloading Node.js source..."
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"

        # Try to download the latest stable release
        if command -v git &> /dev/null; then
            log_info "Cloning Node.js repository..."
            git clone --depth 1 https://github.com/nodejs/node.git
            cd node
        else
            log_error "Git is required to download Node.js source"
            log_info "Please install git or run this script from the Node.js source directory"
            exit 1
        fi

        SOURCE_DIR="$(pwd)"
    fi
}

# Configure Node.js build
configure_build() {
    log_info "Configuring Node.js build..."

    cd "$SOURCE_DIR"

    # Configure with prefix
    ./configure --prefix="$INSTALL_PREFIX"

    log_info "Configuration complete"
}

# Build Node.js
build_nodejs() {
    log_info "Building Node.js (this may take a while)..."

    cd "$SOURCE_DIR"

    # Determine number of parallel jobs
    if command -v nproc &> /dev/null; then
        JOBS=$(nproc)
    elif command -v sysctl &> /dev/null; then
        JOBS=$(sysctl -n hw.ncpu)
    else
        JOBS=2
    fi

    log_info "Building with $JOBS parallel jobs..."
    make -j"$JOBS"

    log_info "Build complete"
}

# Install Node.js
install_nodejs() {
    log_info "Installing Node.js to $INSTALL_PREFIX..."

    cd "$SOURCE_DIR"

    if [ "$IS_ROOT" = true ]; then
        make install
    else
        # For non-root installs, create the directory structure
        mkdir -p "$INSTALL_PREFIX"
        make install
    fi

    log_info "Installation complete"
}

# Update PATH
update_path() {
    local shell_rc=""

    # Detect shell and rc file
    case "$SHELL" in
        */bash)
            shell_rc="$HOME/.bashrc"
            ;;
        */zsh)
            shell_rc="$HOME/.zshrc"
            ;;
        */fish)
            shell_rc="$HOME/.config/fish/config.fish"
            ;;
        *)
            shell_rc="$HOME/.profile"
            ;;
    esac

    if [ "$IS_ROOT" = false ]; then
        # Check if PATH already contains the install prefix
        if ! echo "$PATH" | grep -q "$INSTALL_PREFIX/bin"; then
            log_info "Adding $INSTALL_PREFIX/bin to PATH in $shell_rc"

            echo "" >> "$shell_rc"
            echo "# Node.js (installed via install.sh)" >> "$shell_rc"
            echo "export PATH=\"$INSTALL_PREFIX/bin:\$PATH\"" >> "$shell_rc"

            log_warn "Please run: source $shell_rc"
            log_warn "Or restart your shell to use Node.js"
        fi
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."

    if [ "$IS_ROOT" = false ]; then
        export PATH="$INSTALL_PREFIX/bin:$PATH"
    fi

    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        log_info "Node.js version: $NODE_VERSION"

        if command -v npm &> /dev/null; then
            NPM_VERSION=$(npm --version)
            log_info "npm version: $NPM_VERSION"
        fi

        echo ""
        log_info "Installation successful!"
        echo ""
        log_info "Node.js has been installed to: $INSTALL_PREFIX"
        log_info "Run 'node --version' to verify"
    else
        log_error "Installation verification failed"
        exit 1
    fi
}

# Main installation flow
main() {
    echo ""
    log_info "Node.js Installation Script"
    log_info "============================"
    echo ""

    detect_platform
    check_root
    check_dependencies
    get_source
    configure_build
    build_nodejs
    install_nodejs
    update_path
    verify_installation

    echo ""
    log_info "Thank you for installing Node.js!"
    echo ""
}

# Run main installation
main
