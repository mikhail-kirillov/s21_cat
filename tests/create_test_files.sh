#!/bin/bash

# Check if the correct number of arguments is provided
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 forward_file backward_file"
  exit 1
fi

FORWARD_FILE="$1"
BACKWARD_FILE="$2"

# File forward (from 0 to 127)
echo -n "" > "$FORWARD_FILE"
for i in $(seq 0 127); do
    printf "\\x$(printf %x $i)" >> "$FORWARD_FILE"
done
echo "Created file: $FORWARD_FILE"

# File backward (from 127 to 0)
echo -n "" > "$BACKWARD_FILE"
for i in $(seq 127 -1 0); do
    printf "\\x$(printf %x $i)" >> "$BACKWARD_FILE"
done
echo "Created file: $BACKWARD_FILE"
