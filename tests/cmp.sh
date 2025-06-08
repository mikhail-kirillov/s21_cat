#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

if [[ -z "$1" || -z "$2" ]]; then
  echo -e "${RED}Usage: $0 /path/to/s21_cat file1 file2${RESET}"
  exit 1
fi

S21_CAT="$1"
FILES=("$2" "$3")

if [[ ! -x "$S21_CAT" ]]; then
  echo -e "${RED}Error: $S21_CAT not found or not executable.${RESET}"
  exit 1
fi

for FILE in "${FILES[@]}"; do
  if [[ ! -f "$FILE" ]]; then
    echo -e "${RED}File $FILE not found.${RESET}"
    exit 1
  fi
done

FLAGS=(-b -e -n -s -t -v)
NUM_FLAGS=${#FLAGS[@]}

for ((i=0; i<2**NUM_FLAGS; i++)); do
  COMBO=""
  for ((j=0; j<NUM_FLAGS; j++)); do
    if (( (i >> j) & 1 )); then
      COMBO+=" ${FLAGS[j]}"
    fi
  done

  for FILE in "${FILES[@]}"; do
    rm -f cat_output.txt s21_output.txt

    eval cat $COMBO "$FILE" > cat_output.txt 2> /dev/null
    eval "$S21_CAT" $COMBO "$FILE" > s21_output.txt 2> /dev/null

    if diff -q cat_output.txt s21_output.txt > /dev/null; then
      echo -e "${GREEN}[OK]${RESET} Flags: '$COMBO' File: $FILE"
    else
      echo -e "${RED}[FAIL]${RESET} Flags: '$COMBO' File: $FILE"
      exit 1 # Stop on first failure
    fi
  done
done
