# -IT3038C-BashProject

## Overview
The CSV Processor is a command-line tool designed to process CSV files by filtering rows, sorting data, or calculating sums for numeric columns. This tool is useful for handling large datasets and automating common CSV operations.

## Features

Filter Rows: Filter rows based on a regular expression in a specific column.

Sort Rows: Sort CSV rows by a specified column (text or numeric).

Sum Columns: Calculate the sum of values in a numeric column.

Help Option (-h): Displays usage instructions.

Error Handling: Handles invalid inputs, missing files, and incorrect column names.


## Usage

### Syntax

./csv_processor.sh [option] [column] [csv file]

### options

-f : Filter rows using a regex on the specified column.

-s : Sort rows by the specified column.

-c : Calculate the sum of values in the specified numeric column.

-h : Display help message.

## Example Commands

### Filter by name:

./csv_processor.sh -f 'Name' test.csv

### Sort by age:

./csv_processor.sh -s 'Age' test.csv

### Sum of sales:


./csv_processor.sh -c 'Sales' test.csv




