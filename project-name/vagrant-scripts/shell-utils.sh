#!/usr/bin/env bash

# RAG colors plus color reset for the status indicators (see below)
color_red=$(tput setaf 1)
color_amber=$(tput setaf 3)
color_green=$(tput setaf 76)
color_reset=$(tput sgr0)

# to get real timestamp values `date` needs to be called each time from inside a function
timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# automatically calculates the number of fill characters required based on the length of the title text
print_header() {
  title=$1
  title_length=${#title}
  output_area_width=76
  fill_character="*"
  number_of_fill_characters=$(((($output_area_width-2)-$title_length)/2))
  printf '%*s' "$number_of_fill_characters" | tr ' ' "$fill_character"
  if [ $((title_length%2)) -eq 0 ]; then
    printf '%s' " $title "
  else
    printf '%s' " $title $fill_character"
  fi
  printf '%*s\n' "$number_of_fill_characters" | tr ' ' "$fill_character"
}

# prints message with or without a line break; specify the new line as a second parameter
# example: print_message "Usage: ./$script_name <parameter>" "\n"
print_message() {
  message=$1
  line_break=$2
  printf "%-67s${line_break}" "=== $message"
}

# prints message in the first column (left aligned) and optionally prints an additional text
# as a new column (right aligned); optionally a line break can be added
# example: print_message_with_param "Checking SQLite database..." "main.db" "\n"
print_message_with_param() {
  message=$1
  param=$2
  line_break=$3
  printf "%-38s %28s${line_break}" "=== $message" $param
}

# prints message line starting with a timestamp
print_message_with_timestamp() {
  message=$1
  line_break=$2
  printf "%-67s${line_break}" "$(timestamp) === $message"
}

# appends a (right aligned) red error message to the same line
indicator_red() {
  printf "${color_red}%9s${color_reset}\n" "[FAILED]"
}

# appends a (right aligned) amber/yellow/brown warning message to the same line
indicator_amber() {
  printf "${color_amber}%9s${color_reset}\n" "[!!]"
}

# appends a (right aligned) green status message to the same line
indicator_green() {
  printf "${color_green}%9s${color_reset}\n" "[OK]"
}

# measuring total running time of a script:

time_script_start() {
  start=$(date +%s.%n)
}

time_script_end() {
  end=$(date +%s.%n)
}

time_script_total_runtime() {
  diff=$(echo "$end - $start" | bc)
  print_message "Total runtime: $diff seconds" "\n"
}

# Usage for the above:
#
# Put the following lines into the main control flow of your script:
#
#  time_script_start
#
#  main script control flow steps...
#
#  time_script_end
#  time_script_total_runtime
#
# This will measure the total run time and print out the following:
#
#  === Total runtime: ... seconds
