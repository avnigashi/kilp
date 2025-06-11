# kilp - Process Killer Tool

A command-line utility for Ubuntu/Debian systems that allows you to easily kill processes by port, PID, or process name.

## Features

- **Kill by Port**: Kill processes using a specific port
- **Kill by PID**: Kill a specific process by its Process ID
- **Kill by Name**: Kill processes by their name pattern
- **Safety Features**: Confirmation prompts and permission checks
- **Force Kill**: Option to use SIGKILL instead of SIGTERM
- **Colorized Output**: Easy-to-read colored terminal output

## Installation

### Prerequisites

- Ubuntu/Debian-based Linux system
- sudo privileges for installation

### Quick Installation

1. **Download the files**: Save both `kilp` and `install.sh` scripts to the same directory

2. **Make the installer executable**:
   ```bash
   chmod +x install.sh
   ```

3. **Run the installer**:
   ```bash
   sudo ./install.sh
   ```

The installer will:
- Install required dependencies (`lsof`, `procps`)
- Copy `kilp` to `/usr/local/bin/`
- Make it executable
- Create an uninstaller script

### Manual Installation

If you prefer to install manually:

1. Make the script executable:
   ```bash
   chmod +x kilp
   ```

2. Copy to system directory:
   ```bash
   sudo cp kilp /usr/local/bin/
   ```

3. Install dependencies:
   ```bash
   sudo apt-get update
   sudo apt-get install lsof procps
   ```

## Usage

### Basic Syntax

```bash
kilp [OPTIONS] --port <port> | --pid <pid> | --name <process_name>
```

### Options

- `--port <port>`: Kill process using specified port (1-65535)
- `--pid <pid>`: Kill process with specified PID
- `--name <process_name>`: Kill processes matching the name pattern
- `-f, --force`: Force kill using SIGKILL instead of SIGTERM
- `-y, --yes`: Skip confirmation prompt
- `--help`: Show help message
- `--version`: Show version information

### Examples

#### Kill by Port
```bash
# Kill process using port 3001
kilp --port 3001

# Force kill process on port 8080 without confirmation
kilp --port 8080 --force --yes
```

#### Kill by PID
```bash
# Kill process with PID 3345
kilp --pid 3345

# Force kill PID 1234 without confirmation
kilp --pid 1234 --force --yes
```

#### Kill by Process Name
```bash
# Kill all processes named 'node'
kilp --name node

# Kill processes matching 'python3' pattern
kilp --name python3

# Force kill all nginx processes
kilp --name nginx --force
```

#### Getting Help
```bash
# Show help
kilp --help

# Show version
kilp --version
```

## Safety Features

### Confirmation Prompts
By default, `kilp` shows you the processes it found and asks for confirmation before killing them. You can skip this with the `--yes` flag.

### Permission Checks
The tool checks if you have permission to kill a process and warns you if you might need sudo privileges.

### Process Information
Before killing, `kilp` displays detailed information about the target processes including PID, PPID, user, and command.

## Signal Types

- **Default (SIGTERM)**: Graceful termination that allows processes to clean up
- **Force (SIGKILL)**: Immediate termination with `--force` flag (use with caution)

## Dependencies

- `lsof`: For finding processes by port
- `procps`: For process management utilities (pgrep, ps)
- `bash`: Shell interpreter (usually pre-installed)

## Troubleshooting

### Permission Denied
If you get permission denied errors:
```bash
# Try with sudo
sudo kilp --port 3001
```

### Command Not Found
If `kilp` command is not found after installation:
```bash
# Check if it's in PATH
which kilp

# If not found, try:
export PATH="/usr/local/bin:$PATH"

# Or add to your ~/.bashrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Missing Dependencies
If you see missing tool errors:
```bash
# Install manually
sudo apt-get update
sudo apt-get install lsof procps
```

## Uninstallation

To remove `kilp` from your system:
```bash
sudo kilp-uninstall
```

## Examples in Practice

### Web Development
```bash
# Kill development server on port 3000
kilp --port 3000

# Kill React development server
kilp --name "react-scripts"
```

### System Administration
```bash
# Kill hung SSH connection
kilp --port 22

# Kill all python processes
kilp --name python --force

# Kill specific process by PID
kilp --pid 1234
```

### Docker/Containers
```bash
# Kill process using port bound by container
kilp --port 8080

# Kill Docker processes
kilp --name docker
```
