# Pacman wrap for apt
## About

This plugin reworks the default APT package manager 
to behave like the Pacman package manager.

## Usage

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

For more info see:

```bash
pacman --help
```

## Installation

First, clone the repository:

```bash
git clone https://github.com/Danyl0999/pacman-wrap-for-apt.git ~/.pacman_wrap
```

Then add the following line to your **.bashrc** file:

```bash
source ~/.pacman_wrap/pacman.sh
```
