# Pacman wrap for apt
## About

This plugin reworks the default `APT package manager` 
to behave like the `Pacman` package manager.

This is useful for users transitioning from Arch Linux to Debian/Ubuntu-based systems
or anyone who prefers the `pacman` command syntax.

## Features

- Mimics most commonly used `pacman` commands.
- Supports `.deb` installation (`-U`), download (`-G`) and cache cleaning
- Lists orphaned packages, manually installed packages and more
- Includes `--help` output for all flags

## Usage examples

> Install package

```bash
pacman -S <package-name>
```

> Remove package

```bash
pacman -R <package-name>
```

> Update system

```bash
pacman -Syu
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

First, clone the repository:

```bash
git clone https://github.com/Danyl0999/pacman-wrap-for-apt.git ~/.pacman_wrap
```

Then, source it in your shell startup file:

For **Bash** (`~/.bashrc`):

```bash
source ~/.pacman_wrap/pacman.sh
```

For **Zsh** (`~/.zshrc`):

```bash
source ~/.pacman_wrap/pacman.sh
```

Apply changes:

```bash
source ~/.bashrc
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for more details.
