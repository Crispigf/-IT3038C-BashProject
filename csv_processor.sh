#!/bin/bash

# Function to display the help message
show_help() {
  echo "Usage: ./csv_processor.sh [OPTIONS] [FILE]"
  echo
  echo "Options:"
  echo "  -f COLUMN_NAME  Filter rows by a regex pattern in the specified column"
  echo "  -s COLUMN_NAME  Sort the file by the specified column"
  echo "  -c COLUMN_NAME  Calculate the sum of values in the specified column (numeric)"
  echo "  -h              Display this help message"
  echo
  echo "Example:"
  echo "  ./csv_processor.sh -f 'Name' -r 'John.*' file.csv"
  echo "  ./csv_processor.sh -s 'Age' file.csv"
  echo "  ./csv_processor.sh -c 'Sales' file.csv"
}

# Error message function
error_msg() {
  echo "Error: $1"
  echo "Use -h for help"
  exit 1
}

# Check for arguments
if [ $# -eq 0 ]; then
  error_msg "No arguments provided."
fi

# Process command-line arguments
while getopts ":f:s:c:h" option; do
  case $option in
    f) filter_column="$OPTARG";;
    s) sort_column="$OPTARG";;
    c) calc_column="$OPTARG";;
    h) show_help; exit 0;;
    \?) error_msg "Invalid option -$OPTARG";;
  esac
done

# Shift positional parameters after options
shift $((OPTIND -1))

# Check if a file is provided
file=$1
if [ -z "$file" ]; then
  error_msg "No file provided."
fi

# Ensure file exists
if [ ! -f "$file" ]; then
  error_msg "File does not exist."
fi

# Extract header and data
header=$(head -n 1 "$file")
data=$(tail -n +2 "$file")

# Convert the header to an array for column indices
IFS=',' read -r -a columns <<< "$header"

# Function to find the column index by name
get_column_index() {
  for i in "${!columns[@]}"; do
    if [[ "${columns[$i]}" == "$1" ]]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

# Perform filtering 
if [ -n "$filter_column" ]; then
  filter_index=$(get_column_index "$filter_column")
  if [ $? -ne 0 ]; then
    error_msg "Column '$filter_column' not found."
  fi

  # Ask user for regex pattern
  read -p "Enter regex pattern to filter by: " pattern

  echo "$header"
  echo "$data" | awk -F, -v idx="$filter_index" -v pat="$pattern" '$((idx + 1)) ~ pat'
fi

# Perform sorting
if [ -n "$sort_column" ]; then
  sort_index=$(get_column_index "$sort_column")
  if [ $? -ne 0 ]; then
    error_msg "Column '$sort_column' not found."
  fi

  echo "$header"
  echo "$data" | sort -t, -k$((sort_index + 1)),$((sort_index + 1))
fi

# sum calculation 
if [ -n "$calc_column" ]; then
  calc_index=$(get_column_index "$calc_column")
  if [ $? -ne 0 ]; then
    error_msg "Column '$calc_column' not found."
  fi

  sum=$(echo "$data" | awk -F, -v idx="$calc_index" '{sum += $((idx + 1))} END {print sum}')
  echo "Sum of column '$calc_column': $sum"
fi
