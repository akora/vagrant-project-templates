#!/usr/bin/env bash

three_columns="%-14s %-32s %-28s\n"
four_columns="%-14s %-15s %-16s %-28s\n"

printf "****************************** Version checks ******************************\n"

# the below list is case sensitive!
packages=(python perl ruby php bash git java node npm)

if [[ "`java -version 2>&1 | awk 'NR==2 {print $1}'`" == "OpenJDK" ]]; then
  java_origin="OpenJDK"
else
  java_origin="Oracle"
fi

for package in ${packages[@]}; do
  if command -v $package >/dev/null 2>&1; then # one way of checking if package is installed or not
    path="$(echo `which $package`)"
    # I wish the below wasn't necessary...
    case $package in
      "python")     version="$(echo `$package -c 'import sys; print(sys.version[:5])'`)";;
      "perl")       version="$($package -v | awk 'NR==2 {print $9}' | cut -c3-8)";;
      "ruby")       version="$($package -v | awk '{print $2}' | cut -c1-5)";;
      "php")        version="$(echo `$package -v` | awk '{print $2}' | cut -c1-6)";;
      "bash")       version="$($package --version | awk 'NR==1 {print $4}' | cut -c1-6)";;
      "git")        version="$($package --version | awk '{print $3}')";;
      "java")       version="$($package -version 2>&1 | awk -F '"' '/version/ {print $2}')" note="($java_origin)";;
      *)            version="$(echo `$package -v`)";;
    esac
    if [[ "$version" =~ "v" ]]; then # remove the initial 'v' where necessary
      version="$(echo $version | cut -c2-)"
    fi
    if [[ -z "$note" ]]; then # arrange into 3 columns only if there is no note
      printf "$three_columns" $package $version $path
    else
      printf "$four_columns" $package $version $note $path
    fi
  else
    printf "$three_columns" $package "------" "not installed"
  fi
done

# TODO: extend it to check the latest stable version of each package
# Is there such a service out there?
