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
      sudo apt install -y "$@"
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
    -Ar)
      sudo apt autoremove
      ;;
    -Ac)
      sudo apt autoclean
      ;;
    -C)
      sudo apt clean
      ;;
    -Sy)
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
        sudo apt install -y "./$file"
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
    --help|-h)
      echo "Supported flags:"
      echo "  -S     → install"
      echo "  -G     → download package as .deb file"
      echo "  -U     → install from .deb file"
      echo "  -R     → remove"
      echo "  -Ss    → search"
      echo "  -Syu   → update and upgrade"
      echo "  -Qi    → show package info"
      echo "  -Q     → query installed"
      echo "  -Ar    → autoremove"
      echo "  -Ac    → autoclean"
      echo "  -C     → clean"
      ;;
    --version|-v)
      echo "pacman wrapper v1.0"
      ;;
    *)
      echo "E: Unsupported command." >&2
      echo "Use --help to show help"
      return 1
  esac
}
