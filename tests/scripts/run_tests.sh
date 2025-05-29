#!/bin/bash

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 /path/to/s21_cat forward_file backward_file"
  exit 1
fi

S21_CAT="$1"
FORWARD_FILE="$2"
BACKWARD_FILE="$3"

# Create test files
./create_test_files.sh "$FORWARD_FILE" "$BACKWARD_FILE"

# Run tests
./diff_tests_cats.sh "$S21_CAT" "$FORWARD_FILE" "$BACKWARD_FILE"
if [[ $? -ne 0 ]]; then
  echo "Tests failed"
  echo ""
  different=$(diff -ac ./cat_output.txt ./s21_output.txt)
  echo "\'$different\'"
  echo ""
  echo "Check the output files for details."
  exit 1
fi



# Delete test files
rm -f "$FORWARD_FILE" "$BACKWARD_FILE"
rm -f cat_output.txt s21_output.txt
echo "Test files removed"
