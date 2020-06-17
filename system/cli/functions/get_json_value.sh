#!/usr/bin/env bash

# Extracts a json value from a json containing string
#
# Usage:
# get_json_value <key> [occurrence]
#
# Examples:
# echo $string | get_json_value theKey 1
# cat file.json | get_json_value theKey
#
# Outputs:
# The value at key
function get_json_value() {
    if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
        error "Invalid arguments passed to get_json_value()"
        exit 1
    fi

    local key=$1
    local occurrence=$2

    awk -F "[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$key'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${occurrence}p
}

# Extracts a json value from a json file
#
# Usage:
# get_json_value <file> <key> [occurrence]
#
# Outputs:
# The value at key
function get_json_value_file() {
    if [[ $# -lt 2 ]] || [[ $# -gt 3 ]]; then
        error "Invalid arguments passed to get_json_value_file()"
        exit 1
    fi

    local file=$1
    local key=$2
    local occurrence=$3

    if [[ ! -f $file ]]; then
        error "$file not found"
        exit 1
    fi

    cat $file | get_json_value $key $occurrence
}
