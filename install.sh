#!/bin/bash

# kilp Installation Script
# This script installs the kilp command-line tool on Ubuntu/Debian systems

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="kilp"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Function to log messages
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Check if kilp script exists in current directory
check_script_exists() {
    if [[ ! -f "./kilp" ]]; then
        log_error "kilp script not found in current directory"
        echo "Please make sure the kilp script is in the same directory as this installer"
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    log_info "Checking and installing dependencies..."
    
    # Update package list
    apt-get update >/dev/null 2>&1
    
    # Install required packages
    local packages=("lsof" "procps")
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            missing_packages+=("$package")
        fi
    done
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log_info "Installing missing packages: ${missing_packages[*]}"
        apt-get install -y "${missing_packages[@]}"
        log_success "Dependencies installed successfully"
    else
        log_info "All dependencies are already installed"
    fi
}

# Install the kilp script
install_script() {
    log_info "Installing kilp script to $SCRIPT_PATH..."
    
    # Copy script to installation directory
    cp "./kilp" "$SCRIPT_PATH"
    
    # Make it executable
    chmod +x "$SCRIPT_PATH"
    
    # Verify installation
    if [[ -x "$SCRIPT_PATH" ]]; then
        log_success "kilp installed successfully"
    else
        log_error "Installation failed"
        exit 1
    fi
}

# Create uninstaller
create_uninstaller() {
    local uninstaller_path="/usr/local/bin/kilp-uninstall"
    
    log_info "Creating uninstaller at $uninstaller_path..."
    
    cat > "$uninstaller_path" << 'EOF'
#!/bin/bash

# kilp Uninstaller Script

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (use sudo)"
    exit 1
fi

log_info "Uninstalling kilp..."

if [[ -f "/usr/local/bin/kilp" ]]; then
    rm "/usr/local/bin/kilp"
    log_success "kilp removed"
else
    log_info "kilp not found"
fi

rm "/usr/local/bin/kilp-uninstall"
log_success "kilp completely uninstalled"
EOF
    
    chmod +x "$uninstaller_path"
    log_success "Uninstaller created at $uninstaller_path"
}

# Test installation
test_installation() {
    log_info "Testing installation..."
    
    if command -v kilp >/dev/null 2>&1; then
        log_success "kilp is available in PATH"
        echo
        kilp --version
        echo
        log_info "Installation completed successfully!"
        echo
        echo "Usage examples:"
        echo "  kilp --port 3001        # Kill process using port 3001"
        echo "  kilp --pid 3345         # Kill process with PID 3345"
        echo "  kilp --name node        # Kill processes named 'node'"
        echo "  kilp --help             # Show help"
        echo
        echo "To uninstall: sudo kilp-uninstall"
    else
        log_error "kilp is not available in PATH after installation"
        exit 1
    fi
}

# Main installation process
main() {
    echo -e "${BLUE}kilp Installation Script${NC}"
    echo "=============================="
    echo
    
    check_root
    check_script_exists
    install_dependencies
    install_script
    create_uninstaller
    test_installation
}

# Run main function
main
