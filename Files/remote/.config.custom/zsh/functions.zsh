#!/usr/bin/env zsh

sedit() {
  local file="$1"
  local base tmp orig_checksum new_checksum
  local reply

  # ---- colors ----
  local RED=$'\033[31m'
  local GREEN=$'\033[32m'
  local YELLOW=$'\033[33m'
  local BLUE=$'\033[34m'
  local RESET=$'\033[0m'

  # ---- sanity checks ----
  if [[ -z "$file" ]]; then
    echo "${RED}Usage: sedit <file>${RESET}" >&2
    return 1
  fi

  if [[ ! -e "$file" ]]; then
    echo "${RED}sedit: file does not exist: $file${RESET}" >&2
    return 1
  fi

  if [[ ! -r "$file" ]]; then
    echo "${RED}sedit: file not readable: $file${RESET}" >&2
    return 1
  fi

  base=$(basename -- "$file") || return 1
  tmp=$(mktemp "/tmp/sedit.XXX".${base}) || {
    echo "${RED}sedit: mktemp failed${RESET}" >&2
    return 1
  }

  # Deferred deletion of tmp file to always block

  {
    # ---- copy original ----
    if ! sudo cp --preserve=mode,ownership,timestamps "$file" "$tmp"; then
      echo "${RED}sedit: failed to copy file with sudo${RESET}" >&2
      return 1
    fi

    if ! sudo chown "$USER": "$tmp"; then
      echo "${RED}sedit: failed to change user of tmp file${RESET}" >&2
      return 1
    fi

    orig_checksum=$(sha256sum "$tmp" | awk '{print $1}')

    # ---- edit ----
    "${SUDO_EDITOR:-${EDITOR:-vim}}" "$tmp"
    local edit_status="$?"

    if [[ $edit_status -ne 0 ]]; then
      echo "${RED}sedit: editor exited with error — aborting${RESET}" >&2
      return 1
    fi

    # ---- empty file safeguard ----
    if [[ ! -s "$tmp" ]]; then
      print -P "${YELLOW}sedit: edited file is empty${RESET}"
      printf "%s" "${YELLOW}Overwrite original anyway? [y/N] ${RESET}"
      read -rk 1 reply
      echo
      [[ $reply == [Yy] ]] || {
        print -P "${BLUE}sedit: aborted${RESET}"
        return 1
      }
    fi

    # ---- change detection ----
    new_checksum=$(sha256sum "$tmp" | awk '{print $1}')
    if [[ "$orig_checksum" == "$new_checksum" ]]; then
      echo "${BLUE}sedit: no changes made${RESET}"
      return 0
    fi

    # ---- write back ----
    if ! sudo cp --preserve=mode,ownership,timestamps "$tmp" "$file"; then
      echo "${RED}sedit: failed to write file with sudo${RESET}" >&2
      return 1
    fi

  } always {
    rm -f "$tmp"
  }
}

