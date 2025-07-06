# Pacman wrap for apt
## About

This tool reworks the default `APT package manager` 
to behave like the `Pacman package manager`.

This is useful for users transitioning from Arch Linux to Debian-based systems
or anyone who prefers the `pacman` command syntax.

## Features

- Mimics most commonly used `pacman` commands.
- Supports `.deb` installation (`-U`), download (`-G`) and cache cleaning
- Lists orphaned packages, manually installed packages and more
- Includes `--help` output for all flags

## Usage examples

> Install package

```bash
sudo pacman -S <package-name>
```

> Remove package

```bash
sudo pacman -R <package-name>
```

> Update system

```bash
sudo pacman -Syu
```

> Search in repositories

```bash
pacman -Ss
```

For more info see:

```bash
pacman --help
```

## Installation

### 1. Install Dependencies

This wrapper script requires the following packages to be installed on your system:

- `apt` (already included in Debian-based systems)
- `deborphan` (optional but recommended for orphan package detection)

To install dependencies, run:

```bash
sudo apt update
sudo apt install -y deborphan
```

### 2. Clone the Repository

Clone the repository to your home directory:

```bash
git clone https://github.com/Danyl0999/pacman-wrap-for-apt.git ~/.pacman_wrap
```

### 3. Make the Script Executable and Create link

Make the wrapper script executable and create a link to `/usr/local/bin/pacman`:

```bash
chmod +x ~/.pacman_wrap/pacman.sh
sudo ln ~/.pacman_wrap/pacman.sh /usr/local/bin/pacman
```

### 4. Verify Installation

You can verify the installation by running:
```
pacman --version
```

This should display the wrapper version information.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for more details.
