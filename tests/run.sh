#!/bin/bash

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 /path/to/s21_cat forward_file backward_file"
  exit 1
fi

S21_CAT="$1"
FORWARD_FILE="$2"
BACKWARD_FILE="$3"

./touch.sh "$FORWARD_FILE" "$BACKWARD_FILE"

./cmp.sh "$S21_CAT" "$FORWARD_FILE" "$BACKWARD_FILE"
if [[ $? -ne 0 ]]; then
  echo ""
  different=$(diff -ac ./cat_output.txt ./s21_output.txt)
  echo -e "'\n\n$different\n\n'"
  echo ""
  exit 1
fi


rm -f "$FORWARD_FILE" "$BACKWARD_FILE"
rm -f cat_output.txt s21_output.txt
