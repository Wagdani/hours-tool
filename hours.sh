#!/usr/bin/env bash
# hours.sh - total up logged hours per person from a simple CSV.
#
# Usage: ./hours.sh <file.csv>
#
# Expects a header row, then one "name,hours" record per line:
#
#   name,hours
#   Amina,2.5
#   Rashid,1
#   Amina,0.5
#
# Blank lines are ignored, and surrounding whitespace is trimmed from
# each field, so "Amina" and " Amina" count as the same person.
#
# Prints one "name,total" line per person, sorted by name.

set -euo pipefail

main() {
  if [ $# -ne 1 ]; then
    echo "usage: hours.sh <file.csv>" >&2
    return 2
  fi

  local file=$1
  if [ ! -f "$file" ]; then
    echo "hours.sh: no such file: $file" >&2
    return 1
  fi

  awk -F, '
    NR == 1 { next }                       # skip the header row
    { sub(/\r$/, "") }                     # tolerate CRLF input
    /^[[:space:]]*$/ { next }              # skip blank lines
    {
      name = $1
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
      if (name == "") next                 # skip records with no name
      total[name] += $2
    }
    END { for (name in total) printf "%s,%.2f\n", name, total[name] }
  ' "$file" | sort
}

main "$@"
