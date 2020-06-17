#!/usr/bin/env bash

# Runs a command file from a given command string
#
# Usage:
# run_command <command>
#
# Returns:
# Hard set error status code provided by this function or the run command's exit/return code.
function run_command() {
    if [[ -z ${APP_ROOT} ]]; then
        warning "Failed to determine APP_ROOT"
    fi

    local commandRoot="$APP_ROOT/system/cli/commands";
    if [[ ! -d "$commandRoot" ]]; then
        error "Failed to find commands at: $commandRoot"
        return 1
    fi

    # Grab and validate command
    command="$1"
    shift # Remove consumed arg
    if [[ -z $command ]]; then
        error "No command provided"
        return 1
    fi

    # Determine command file path, load it
    # : delimited commands turned into nested paths /
    commandFilePath="$commandRoot/${command//://}.sh"
    if [[ -f "$commandFilePath" ]]; then
        . "$commandFilePath"
        return $?
    fi

    # Default to unhandled command
    error "Unknown command" "$command"
    return 1
}
