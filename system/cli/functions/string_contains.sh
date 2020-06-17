#!/usr/bin/env bash

# Determines if a string contains a given sub string
#
# Usage:
# string_contains <haystack> <needle>
#
# Returns:
# Int representations of true/false
function string_contains() {
    if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
        error "Invalid arguments passed to get_json_value()"
        exit 1
    fi

    if [[ $1 == *"${2}"* ]]; then
        return 0; #true
    else
        return 1; #false
    fi
}
