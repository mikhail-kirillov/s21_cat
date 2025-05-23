#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Reset color

# Check if the correct number of arguments is provided
if [[ -z "$1" || -z "$2" ]]; then
  echo -e "${RED}Usage: $0 /path/to/s21_cat file1 file2${NC}"
  exit 1
fi

S21_CAT="$1"
FILES=("$2" "$3") # Получаем названия файлов из аргументов

# Check if s21_cat exists and is executable
if [[ ! -x "$S21_CAT" ]]; then
  echo -e "${RED}Error: $S21_CAT not found or not executable.${NC}"
  exit 1
fi

# Check if files exist
for FILE in "${FILES[@]}"; do
  if [[ ! -f "$FILE" ]]; then
    echo -e "${RED}File $FILE not found.${NC}"
    exit 1
  fi
done

# All possible flags
FLAGS=(-b -e -n -s -t -v)
NUM_FLAGS=${#FLAGS[@]}

echo "Comparing $S21_CAT and cat with all flag combinations..."

# All possible flag combinations (including empty)
for ((i=0; i<2**NUM_FLAGS; i++)); do
  COMBO=""
  for ((j=0; j<NUM_FLAGS; j++)); do
    if (( (i >> j) & 1 )); then
      COMBO+=" ${FLAGS[j]}"
    fi
  done

  for FILE in "${FILES[@]}"; do
    # Remove previous temp files if they exist
    rm -f cat_output.txt s21_output.txt

    # Run commands
    eval cat $COMBO "$FILE" > cat_output.txt 2> /dev/null
    eval "$S21_CAT" $COMBO "$FILE" > s21_output.txt 2> /dev/null

    # Compare outputs
    if diff -q cat_output.txt s21_output.txt > /dev/null; then
      echo -e "${GREEN}[OK]${NC} Flags: '$COMBO' File: $FILE"
    else
      echo -e "${RED}[FAIL]${NC} Flags: '$COMBO' File: $FILE"
      exit 1 # Stop on first failure
      # Optional: show the actual difference
      # diff -u cat_output.txt s21_output.txt
    fi
  done
done
