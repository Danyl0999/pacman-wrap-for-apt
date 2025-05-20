# Pacman wrap for apt
## About

This pluggin reworks default apt package manager looks like pacman package manager.

## Use
>Install package

`
pacman -S <Package name>
`

>Remove

`
pacman -R <Package name>
`

>Update system

`
pacman -Syu
`

For more info see:

`
pacman --help
`

## Install
First run this:

`
git clone https://github.com/Danyl0999/pacman-apt-wrap.git ~/.pacman_wrap
`

After you run it add this to your `.bashrc` file:

`
source ~/.pacman_wrap/pacman.sh
`
