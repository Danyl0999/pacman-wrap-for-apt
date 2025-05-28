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
    -Sr)
      shift
      sudo apt install --reinstall -y "$@"
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
      flatpak update -y
      ;;
    -Scc)
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
      apt list --installed 2>/dev/null | grep -i "$*"
      ;;
    -Qv)
      if [ $# -eq 0 ]; then
          echo "E: No package specified for version query." >&2
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
          echo "E: No package provided." >&2
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
        sudo apt --purge remove "$@"
      fi
      sudo apt autoremove -y
      ;;
    -Sc)
      sudo apt autoclean
      ;;
    -Sy|-Syy)
      sudo apt update
      ;;
    -Su)
      sudo apt upgrade
      ;;
    -Rs)
      shift
      if [ $# -eq 0  ]; then
          echo "E: No package specified for purge removal." >&2
          return 1
      fi
      sudo apt --purge remove "$@"
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
        sudo dpkg -i "$file" || apt-get -f install
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
    -Ar)
      shift
      if [ $# -eq 0 ]; then
          echo "E: No repository name specified to add." >&2
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
      sudo apt-get install -f
      ;;
    --help|-h)
      echo "Supported flags:"
      echo "  -S         → install package"
      echo "  -Sr        → reinstall package"
      echo "  -G         → download package as .deb file"
      echo "  -U         → install from .deb file"
      echo "  -R         → remove package"
      echo "  -Rs        → remove package with config files"
      echo "  -Ss        → search in repositories"
      echo "  -Syu       → update package list and upgrade"
      echo "  -Sy/Syy    → update package list only"
      echo "  -Su        → upgrade system (don\`t update package list)"
      echo "  -Q         → list installed packages"
      echo "  -Sssec     → check security updates"
      echo "  -Sccc      → fully clean cache and remove unused packages"
      echo "  -Qi        → show package info"
      echo "  -Qe        → list manually installed packages"
      echo "  -Qm        → list foreign packages"
      echo "  -Qs        → search in installed packages"
      echo "  -Qdt       → list orphaned dependencies"
      echo "  -Qk        → verify package integrity"
      echo "  -Qf        → check and fix packages"
      echo "  -Qv        → show package version"
      echo "  -Qq        → list installed packages (quiet, names only)"
      echo "  -Ql        → list files installed by packages"
      echo "  -Rns       → remove package with config"
      echo "  -Sc        → remove old cached .deb files"
      echo "  -Scc       → clear package cache"
      echo "  -Ar        → add apt repository"
      echo "  --help     → show this help"
      echo "  --version  → show version"
      ;;
    --version|-v)
      echo "pacman wrapper v1.1.0"
      ;;
    *)
      echo "E: Unsupported command." >&2
      echo "Use --help to show help"
      return 1
  esac
}
