sedit() {
  local file="$1"
  local base
  local tmp

  base=$(basename -- "$file")
  tmp=$(mktemp /tmp/sedit.${base}.XXXXXX) || return

  sudo cp "$file" "$tmp" || return

  "${SUDO_EDITOR:-vim}" "$tmp"

  sudo cp "$tmp" "$file"
  rm -f "$tmp"
}

