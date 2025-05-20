pacman() {
  if [ $# -eq 0 ]; then
      echo "Use --help to show help."
      return 1
  fi

  case "$1" in
    -S)
      shift
      if [ $# -eq 0  ]; then
          echo "Error: No package specified for install."
          return 1
      fi
      sudo apt install "$@"
      ;;
    -R)
      shift
      if [ $# -eq 0 ]; then
          echo "Error: No package specified for removal."
          return 1
      fi
      sudo apt remove "$@"
      ;;
    -Ss)
      shift
      apt search "$@"
      ;;
    -Syu)
      sudo apt update && sudo apt upgrade
      ;;
    -Qi)
      shift
      if [ $# -eq 0 ]; then
          echo "Error: No package specified for info."
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
    --help|-h)
      echo "Supported flags:"
      echo "  -S     → install"
      echo "  -R     → remove"
      echo "  -Ss    → search"
      echo "  -Syu   → update and upgrade"
      echo "  -Qi    → show package info"
      echo "  -Q     → query installed"
      echo "  -Ar    → autoremove"
      echo "  -Ac    → autoclean"
      echo "  -C     → clean"
      echo "  -Sy    → update"
      ;;
    *)
      echo "Unsupported command."
      echo "Use --help to show help"
  esac
}
