#!/usr/bin/env bash

# --- Holiday theme + prompt manager ---
THEME_DIR="$CONFIG_LOCATION/zsh/holidays/"
today=$(date +%m%d)
year=$(date +%Y)

# --- Function to source a holiday script if within range ---
function load_holiday_theme() {
  local start=$1
  local end=$2
  local script=$3

  if [[ $today -ge $start && $today -le $end ]]; then
    [[ -f "$THEME_DIR/$script" ]] && source "$THEME_DIR/$script"
  fi
}

# Find the Nth Sunday of a given month/year
function nth_sunday() {
  local nth=$1
  local month=$2
  local Y=$3
  local d=1
  while [[ $(date -j -f "%Y-%m-%d" "${Y}-${month}-$(printf '%02d' $d)" +%w 2>/dev/null || date -d "${Y}-${month}-$(printf '%02d' $d)" +%w) -ne 0 ]]; do
    ((d++))
  done
  ((d += 7 * (nth - 1)))
  printf "%02d%02d" "$month" "$d"
}

# Austrian Mother's Day: 3 days before → 2 days after
MOTHERS_DAY=$(nth_sunday 2 05 "$year") # Austrian Mother's Day: 2nd Sunday of May
MOTHERS_START=$(date -d "${year}-$(echo $MOTHERS_DAY | cut -c1-2)-$(echo $MOTHERS_DAY | cut -c3-4) -3 days" +%m%d)
MOTHERS_END=$(date -d "${year}-$(echo $MOTHERS_DAY | cut -c1-2)-$(echo $MOTHERS_DAY | cut -c3-4) +2 days" +%m%d)

# Austrian Father's Day: 3 days before → 2 days after
FATHERS_DAY=$(nth_sunday 2 06 "$year") # Austrian Father's Day: 2nd Sunday of June
FATHERS_START=$(date -d "${year}-$(echo $FATHERS_DAY | cut -c1-2)-$(echo $FATHERS_DAY | cut -c3-4) -3 days" +%m%d)
FATHERS_END=$(date -d "${year}-$(echo $FATHERS_DAY | cut -c1-2)-$(echo $FATHERS_DAY | cut -c3-4) +2 days" +%m%d)

# --- Holiday ranges (MMDD format) ---
# Valentine's Day: Feb 7 – Feb 14
load_holiday_theme 0207 0214 "valentines.sh"

# International Women's Day: March 1 – March 8
load_holiday_theme 0301 0308 "womensday.sh"

# World Health Day: April 1 – April 7
load_holiday_theme 0401 0407 "healthday.sh"

# Earth Day: April 15 – April 22
load_holiday_theme 0415 0422 "earthday.sh"

# Mother's Day
load_holiday_theme "$MOTHERS_START" "$MOTHERS_END" "mothersday.sh"

# World Environment Day: June 1 – June 5
load_holiday_theme 0601 0605 "environmentday.sh"

# Father's Day
load_holiday_theme "$FATHERS_START" "$FATHERS_END" "fathersday.sh"

# International Day of Peace: Sept 14 – Sept 21
load_holiday_theme 0914 0921 "peaceday.sh"

# Halloween: Oct 11 – Oct 31
load_holiday_theme 1011 1031 "halloween.sh"

# World Mental Health Day: Oct 3 – Oct 10
load_holiday_theme 1003 1010 "mentalhealth.sh"

# Christmas: Dec 1 – Dec 25
load_holiday_theme 1201 1225 "christmas.sh"

# New years: Dec 26 - Dec 31
load_holiday_theme 1226 1231 "newyear.sh"

