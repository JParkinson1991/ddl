#!/usr/bin/env bash

# Shows help pages for the given command string
#
# Usage:
# show_help [command]
#
# If no command passed the default help screen is displayed
#
# Returns:
# The status code of help screen load useful if consumers plan to exit post render
function show_help() {
    if [[ -z ${APP_ROOT} ]]; then
        warning "Failed to determine APP_ROOT"
    fi

    local helpRoot="$APP_ROOT/system/cli/help"
    if [[ ! -d "$helpRoot" ]]; then
        error "Failed to find help at: $helpRoot"
        return 1
    fi

    # Parse help command
    local command="$1"

    # If no commands received show default help screen
    if [[ -z $command ]]; then
        cat "$helpRoot/ddl.txt"
        return 0
    fi

    # Determine expected help file path
    # : delimited commands turned into nested paths /
    helpFilePath="$helpRoot/${command//://}.txt"
    if [[ -f "$helpFilePath" ]]; then
        cat "$helpFilePath"
        return 0
    fi

    # Failed to find help screen for command
    error "Unknown Command" "$command"
    notice "Showing default help screen"
    cat "$helpRoot/ddl.txt"
    return 1
}
