#!/bin/bash

# Copyright 2015  Joan Puigcerver

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
# WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
# MERCHANTABLITY OR NON-INFRINGEMENT.
# See the Apache 2 License for the specific language governing permissions and
# limitations under the License.

### This function prints an error message and exits from the shell.
function error () {
    echo "$(date "+%F %T") ERROR: $@" >&2; exit 1;
}

### This function prints an error message, but does not exit from shell.
function error_continue () {
    echo "$(date "+%F %T") ERROR: $@" >&2;
}

### This function shows a warning message.
function warning {
    echo "$(date "+%F %T") WARNING: $@" >&2;
}

### This function shows a info message.
function msg {
    echo "$(date "+%F %T") INFO: $@" >&2;
}

### This function normalizes a floating point number.
### Examples:
### $ normalize_float 3
### 3.0
### $ normalize_float 133333333333333
### 1.33333333e+14
function normalize_float () {
    [ $# -ne 1 ] && echo "Usage: normalize_float <f>" >&2 && return 1;
    LC_NUMERIC=C printf "%.8g" "$1" | awk '{
    if(!match($0, /.+\..+/)) printf("%.1f\n", $0); else print $0; }';
    return 0;
}

function ceil_div () {
    [ $# -ne 2 ] && echo "Usage: py_ceil <num> <den>" >&2 && return 1;
    LC_NUMERIC=C python -c "
from math import ceil
print int(ceil($1 / $2))
"
    return 0;
}

function ceil_mul () {
    [ $# -ne 2 ] && echo "Usage: py_ceil <fact1> <fact2>" >&2 && return 1;
    LC_NUMERIC=C python -c "
from math import ceil
print int(ceil($1 * $2))
"
    return 0;
}

### This function checkes whether a list of executables are available
### in the user's PATH or not.
### Examples:
### $ check_execs HERest cp
### $ check_execs HERest2 cp2
### ERROR: Executable "HERest2" is missing in your PATH!
function check_execs () {
    while [ $# -gt 0 ]; do
	which "$1" &> /dev/null || \
	    error "Executable \"$f\" is missing in your PATH!";
	shift;
    done;
}

### Use this function the check if a set of files exists, are readable and not
### empty.
### Examples:
### $ check_files exist not_exists
### ERROR: File \"not_exists\" does not exist!"
function check_files {
    while [ $# -gt 0 ]; do
        [ -f "$1" ] || error "File \"$1\" does not exist!";
        [ -s "$1" ] || error "File \"$1\" is empty!";
        [ -r "$1" ] || error "File \"$1\" cannot be read!";
        shift;
    done;
}

### Use this function to check wheter a set of directories exist and are
### accessible.
function check_dirs {
    while [ $# -gt 0 ]; do
        [ -d "$1" ] || error "Directory \"$1\" does not exist!";
        [ -r "$1" -a -x "$1" ] || error "Directory \"$1\" cannot be accessed!";
        shift;
    done;
}

### This function creates a bunch of directories with mkdir -p and prints
### a friendly error message if any of them fails.
function make_dirs () {
    while [ $# -gt 0 ]; do
	mkdir -p "$1" || error "Directory \"$1\" could not be created!";
	shift;
    done;
}
