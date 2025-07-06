#!/bin/bash

RED='\e[31m'
RESET='\e[0m'
DRY_RUN=""
RECOMENDATIONS="--no-install-recommends"
VERBOSE=""

for arg in "$@"; do
if [ "$arg" = "--dry-run" ]; then
  DRY_RUN="--simulate"
fi
if [ "$arg" = "--install-recommends" ]; then
  RECOMENDATIONS=""
fi
if [ "$arg" = "--verbose" ] || [ "$arg" = "-v" ]; then
  VERBOSE="-v"
fi
done

if [ $# -eq 0 ]; then
  echo "Use --help to show help."
  exit 1
fi

case "$1" in
-S)
  shift
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  if [ $# -eq 0  ]; then
      echo -e "${RED}E${RESET}: No package specified for install." >&2
      exit 1
  fi
  apt install $RECOMENDATIONS -y $DRY_RUN $VERBOSE "$@"
  ;;
-Sr)
  shift
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  apt install --reinstall -y $DRY_RUN $VERBOSE "$@"
  ;;
-R)
  shift
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified for removal." >&2
      exit 1
  fi
  apt remove -y $DRY_RUN $VERBOSE "$@"
  ;;
-Ss)
  shift
  apt search "$@"
  ;;
-Syu)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  apt update && apt upgrade $VERBOSE $DRY_RUN -y
  ;;
-Scc)
  if [ "$UID" -ne 0 ]; then
    echo -e "${RED}E${RESET}: Permission denied." >&2
    exit 1
  fi
  apt autoclean
  apt clean
  apt autoremove -y
  ;;
-Qi)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified for info." >&2
      exit 1
  fi
  apt show "$@"
  ;;
-Q)
  shift
  apt list --installed "$@"
  ;;
-Qdt)
  if ! command -v deborphan >/dev/null 2>&1; then
    echo -e "${RED}E${RESET}: deborphan is not installed. Please install it first." >&2
    exit 1
  fi
  deborphan
  ;;
-Qe)
  apt-mark showmanual
  ;;
-Qs)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No search term provided." >&2
      exit 1
  fi
  apt list --installed 2>/dev/null | grep -i "$*"
  ;;
-Qv)
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified for version query." >&2
      exit 1
  fi
  dpkg -s "$@" | grep '^Version:'
  ;;
-Qk)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  dpkg --verify
  ;;
-Ql)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package provided." >&2
      exit 1
  fi
  dpkg -L "$@"
  ;;
-Qm)
  apt list --installed 2>/dev/null | grep "\[installed,local\]"
  ;;
-Rns)
  shift
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  if [ $# -ne 0 ]; then
    apt --purge remove -y $DRY_RUN "$@"
  fi
  apt autoremove $DRY_RUN $VERBOSE -y
  ;;
-Sc)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  apt autoclean
  ;;
-Sy|-Syy)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  apt update $DRY_RUN $VERBOSE
  ;;
-Su)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  apt upgrade $DRY_RUN $VERBOSE -y
  ;;
-U)
  shift
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No .deb file specified for install." >&2
      exit 1
  fi
  for file in "$@"; do
    if [[ ! -f "$file" ]]; then
      echo -e "${RED}E${RESET}: File not found: $file" >&2
      exit 1
    fi
    if [[ "$file" != *.deb ]]; then
      echo -e "${RED}E${RESET}: Not a .deb file: $file" >&2
      exit 1
    fi
    dpkg -i "$file" || apt-get -f install $VERBOSE $DRY_RUN -y
  done
  ;;

-G)
  shift
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No package specified to download." >&2
      exit 1
  fi
  apt download "$@"
  ;;
-Qq)
  apt list --installed 2>/dev/null | cut -d/ -f1
  ;;
-Ar)
  shift
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  if [ $# -eq 0 ]; then
      echo -e "${RED}E${RESET}: No repository name specified to add." >&2
      exit 1
  fi
  apt add-repository -y "$*"
  ;;
-Qu)
  apt list --upgradable
  ;;
-Sssec)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  apt update
  apt list --upgradable | grep -i security
  ;;
-Sccc)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  rm -fv /var/cache/apt/*.bin
  rm -fv /var/cache/apt/archives/*.*
  rm -fv /var/lib/apt/lists/*.*
  apt clean
  apt autoclean
  apt autoremove -y
  ;;
-Qf)
  if [ "$UID" -ne 0 ]; then
      echo -e "${RED}E${RESET}: Permission denied." >&2
      exit 1
  fi
  dpkg --configure -a
  apt-get install $DRY_RUN -f -y
  ;;
-Slog)
  grep " install " /var/log/dpkg.log | tail -n 20
  ;;
-Sown)
  shift
  if [ -z "$1" ]; then
      echo -e "${RED}E${RESET}: No file specified." >&2
      exit 1
  fi
  dpkg -S "$1"
  ;;
--help|-h)
    cat "/home/$(whoami)/.pacman_wrap/help.txt"
    ;;
--version|-v)
  echo "pacman wrapper v1.1.5"
  ;;
*)
  echo -e "${RED}E${RESET}: Unsupported command." >&2
  echo "Use --help to show help"
  exit 1
esac
