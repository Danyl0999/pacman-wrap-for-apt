pacman() {
  if [ $# -eq 0 ]; then
      echo "Use --help to show help."
      return 1
  fi

  case "$1" in
    -S)
      shift
      if [ $# -eq 0  ]; then
          echo "E: No package specified for install." >&2
          return 1
      fi
      sudo apt install --no-install-recommends -y "$@"
      ;;
    -R)
      shift
      if [ $# -eq 0 ]; then
          echo "E: No package specified for removal." >&2
          return 1
      fi
      sudo apt remove "$@"
      ;;
    -Ss)
      shift
      apt search "$@"
      ;;
    -Syu)
      sudo apt update && sudo apt upgrade -y
      flatpak update
      ;;
    -Scc)
        sudo apt clean
        sudo apt clean
        ;;
    -Qi)
      shift
      if [ $# -eq 0 ]; then
          echo "E: No package specified for info." >&2
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
          echo "E: No search term provided." >&2
          return 1
      fi
      apt list --installed 2>/dev/null | grep -i "$@"
      ;;
    -Qk)  
      sudo dpkg --verify
      ;;
    -Ar)
      sudo apt autoremove
      ;;
    -Ac)
      sudo apt autoclean
      ;;
    -Sc)
      sudo apt clean
      ;;
    -Sy|-Syy)
      sudo apt update
      ;;
    -U)
      shift
      if [ $# -eq 0 ]; then
          echo "E: No .deb file specified for install." >&2
          return 1
      fi
      for file in "$@"; do
        if [[ ! -f "$file" ]]; then
          echo "E: File not found: $file" >&2
          return 1
        fi
        if [[ "$file" != *.deb ]]; then
          echo "E: Not a .deb file: $file" >&2
          return 1
        fi
        sudo apt install -y "$file"
      done
      ;;

    -G)
      shift
      if [ $# -eq 0 ]; then
          echo "E: No package specified to download." >&2
          return 1
      fi
      apt download "$@"
      ;;
    -Qq)
      apt list --installed 2>/dev/null | cut -d/ -f1
      ;;
    --help|-h)
      echo "Supported flags:"
      echo "  -S     → install packages"
      echo "  -G     → download package as .deb file"
      echo "  -U     → install from .deb file"
      echo "  -R     → remove packages"
      echo "  -Ss    → search in repositories"
      echo "  -Syu   → update package list and upgrade"
      echo "  -Sy/Syy    → update package list only"
      echo "  -Qi    → show package info"
      echo "  -Q     → list installed packages"
      echo "  -Qe    → list manually installed packages"
      echo "  -Qs    → search in installed packages"
      echo "  -Qdt   → list orphaned dependencies"
      echo "  -Qk    → verify package integrity"
      echo "  -Qq    → list installed packages (quiet, names only)"
      echo "  -Ar    → autoremove unused packages"
      echo "  -Ac    → autoclean package cache"
      echo "  -Sc     → clean package cache"
      echo "  -Scc   → fully clean package cache"
      echo "  --help → show this help"
      echo "  --version → show version"
      ;;
    --version|-v)
      echo "pacman wrapper v1.0.4"
      ;;
    *)
      echo "E: Unsupported command." >&2
      echo "Use --help to show help"
      return 1
  esac
}
