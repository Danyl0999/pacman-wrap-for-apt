#!/bin/bash

RED='\e[31m'
RESET='\e[0m'
DRY_RUN=""
RECOMENDATIONS="--no-install-recommends"
FLATPAK=1
VERBOSE=""

for arg in "$@"; do
if [ "$arg" = "--dry-run" ]; then
  DRY_RUN="--simulate"
fi
if [ "$arg" = "--install-recomends" ]; then
  RECOMENDATIONS=""
fi
if [ "$arg" = "--no-flatpak" ]; then
  FLATPAK=0
fi
if [ "$arg" = "--verbose" ] || [ "$arg" = "-v" ]; then
  VERBOSE="-v"
fi
done

if [ $# -eq 0 ]; then
  echo "Use --help to show help."
  return 1
fi

case "$1" in
-S)
  shift
  if [ $# -eq 0  ]; then
      echo -e "${RED}E${RESET}: No package specified for install." >&2
      return 1
  fi
  sudo apt install $RECOMENDATIONS -y $DRY_RUN $VERBOSE "$@"
  ;;
-Sr)
  shift
  sudo apt install --reinstall -y $DRY_RUN $VERBOSE "$@"
  ;;
-R)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified for removal." >&2
      return 1
  fi
  sudo apt remove -y $DRY_RUN $VERBOSE "$@"
  ;;
-Ss)
  shift
  apt search "$@"
  ;;
-Syu)
  sudo apt update && sudo apt upgrade $VERBOSE $DRY_RUN -y
  if [ "$FLATPAK" -eq 1 ]; then
    flatpak update -y
  fi
  ;;
-Scc)
    sudo apt clean
    ;;
-Qi)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified for info." >&2
      return 1
  fi
  apt show "$@"
  ;;
-Q)
  shift
  apt list --installed "$@"
  ;;
-Qdt)
  apt-mark showauto | xargs apt-cache rdepends --installed | grep -B1 "Reverse Depends:" | grep -v "Reverse Depends:" | sort | uniq
  ;;
-Qe)
  apt-mark showmanual
  ;;
-Qs)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No search term provided." >&2
      return 1
  fi
  apt list --installed 2>/dev/null | grep -i "$*"
  ;;
-Qv)
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified for version query." >&2
      return 1
  fi
  dpkg -s "$@" | grep '^Version:'
  ;;
-Qk)
  sudo dpkg --verify
  ;;
-Ql)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package provided." >&2
      return 1
  fi
  dpkg -L "$@"
  ;;
-Qm)
  apt list --installed 2>/dev/null | grep "\[installed,local\]"
  ;;
-Rns)
  shift
  if [ $# -ne 0 ]; then
    sudo apt --purge remove -y $DRY_RUN "$@"
  fi
  sudo apt autoremove $DRY_RUN $VERBOSE -y
  ;;
-Sc)
  sudo apt autoclean
  ;;
-Sy|-Syy)
  sudo apt update $DRY_RUN $VERBOSE
  ;;
-Su)
  sudo apt upgrade $DRY_RUN $VERBOSE -y
  ;;
-U)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No .deb file specified for install." >&2
      return 1
  fi
  for file in "$@"; do
    if [[ ! -f "$file" ]]; then
      echo -e "${RED}E${RESET}: File not found: $file" >&2
      return 1
    fi
    if [[ "$file" != *.deb ]]; then
      echo -e "${RED}E${RESET}: Not a .deb file: $file" >&2
      return 1
    fi
    sudo dpkg -i "$file" || sudo apt-get -f install $VERBOSE $DRY_RUN -y
  done
  ;;

-G)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified to download." >&2
      return 1
  fi
  apt download "$@"
  ;;
-Qq)
  apt list --installed 2>/dev/null | cut -d/ -f1
  ;;
-Ar)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No repository name specified to add." >&2
      return 1
  fi
  sudo apt add-repository -y "$*"
  ;;
-Qu)
  apt list --upgradable
  ;;
-Sssec)
  sudo apt update
  apt list --upgradable | grep -i security
  ;;
-Sccc)
  sudo apt clean
  sudo apt autoclean
  sudo apt autoremove -y
  ;;
-Qf)
  sudo dpkg --configure -a
  sudo apt-get install $DRY_RUN -f -y
  ;;
-Slog)
  grep " install " /var/log/dpkg.log | tail -n 20
  ;;
-Sown)
  shift
  if [ -z "$1" ]; then
      echo -e "${RED}E${RESET}: No file specified." >&2
      return 1
  fi
  dpkg -S "$1"
  ;;
--help|-h)
    cat "/home/$(whoami)/.pacman_wrap/help.txt"
    ;;
--version|-v)
  echo "pacman wrapper v1.1.4"
  ;;
*)
  echo -e "${RED}E${RESET}: Unsupported command." >&2
  echo "Use --help to show help"
  return 1
esac
