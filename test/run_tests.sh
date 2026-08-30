#!/usr/bin/env bash
# Tiny test runner for hours.sh. No dependencies -- just bash.
#
# Usage: ./test/run_tests.sh

set -uo pipefail

cd "$(dirname "$0")/.."
readonly HOURS=./hours.sh

pass=0
fail=0

assert_eq() {
  local label=$1 expected=$2 actual=$3
  if [ "$expected" = "$actual" ]; then
    printf 'ok   - %s\n' "$label"
    pass=$((pass + 1))
  else
    printf 'FAIL - %s\n       expected: %s\n       actual:   %s\n' \
      "$label" "$(printf '%s' "$expected" | tr '\n' '|')" \
      "$(printf '%s' "$actual" | tr '\n' '|')"
    fail=$((fail + 1))
  fi
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# --- a single person, a single row ---------------------------------------
printf 'name,hours\nAmina,2.5\n' > "$tmp/single.csv"
assert_eq "single row is reported as-is" \
  "Amina,2.50" \
  "$($HOURS "$tmp/single.csv")"

# --- repeated names are summed -------------------------------------------
printf 'name,hours\nAmina,2.5\nRashid,1\nAmina,0.5\n' > "$tmp/repeat.csv"
assert_eq "repeated names are summed" \
  "Amina,3.00
Rashid,1.00" \
  "$($HOURS "$tmp/repeat.csv")"

# --- output is sorted by name --------------------------------------------
printf 'name,hours\nZaid,1\nAmina,1\n' > "$tmp/order.csv"
assert_eq "output is sorted by name" \
  "Amina,1.00
Zaid,1.00" \
  "$($HOURS "$tmp/order.csv")"

# --- a missing file is an error ------------------------------------------
$HOURS "$tmp/nope.csv" >/dev/null 2>&1
assert_eq "missing file exits non-zero" "1" "$?"

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
