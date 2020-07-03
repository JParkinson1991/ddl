#!/usr/bin/env bash

# Finds files with a given extension in a given search root
#
# Usage:
# file_num_with_extension <search root> <extenstion>
#
# Examples:
# file_num_with_extension ./directory php
# foundFiles=$(file_num_with_extension ./directory php)
#
# Outputs:
# The number of found files with the extension on success
# Or the error messages
function file_num_with_extension() {
    if [[ $# -ne 2 ]]; then
        error "Invalid arguments passed to find_files_with_extension()"
        exit 1
    fi

    local searchRoot="$1"
    local extension="$2"

    if [[ ! -d "$searchRoot" ]]; then
        error 'Directory not found' "$searchRoot"
        exit 1
    fi

    ls -lR "$searchRoot" | grep --count \."$extension"$

    exit 0
}
