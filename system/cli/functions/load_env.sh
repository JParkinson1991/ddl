#!/usr/bin/env bash

# Loads the environment variables from a .env file if found at the $APP_ROOT
#
# Outer defined environment variables will always take precedence over
# values defined in a .env file.
#
# Usage:
# load_env
function load_env() {
    if [[ -z ${APP_ROOT} ]]; then
        warning "Failed to determine APP_ROOT"
    fi

    # If environment file not found stop execution
    if [[ ! -f "$APP_ROOT/.env" ]]; then
        return 1;
    fi

    # Attempt to load environment variables
    # Differing systems have difference command structures, try multiple
    # If all fail, output message and return
    local envFileVariables=()
    if grep -v '^#' "$APP_ROOT/.env" | xargs -d '\n' >/dev/null 2>&1; then
        envFileVariables=($(grep -v '^#' "$APP_ROOT/.env" | xargs -d '\n'))
    elif grep -v '^#' "$APP_ROOT/.env" | xargs -0 >/dev/null 2>&1; then
        envFileVariables=($(grep -v '^#' "$APP_ROOT/.env" | xargs -0))
    else
        error "Failed to parse $APP_ROOT/.env"
        return 1;
    fi

    # .env file loaded, prepare array to hold variables to export
    local exportVariables=()

    # Process the variables and values from .env ensuring no outer variables
    # are overwritten if they already exist
    for envVar in ${envFileVariables[@]}
    do
        # Split the VAR=VALUE by '=' capture the variable name
        local variableName="${envVar%%=*}"

        # If a value already exists for this variable, skip it
        # Outer environment variable definitions always take precedence
        # Use ${! notation for variable variable names
        if [[ -n ${!variableName} ]]; then
            continue
        fi

        # Variable value does not exist in environment, add to export array
        exportVariables+=("$envVar")
    done

    # Export the variables from .env where they dont already exist
    export ${exportVariables[@]}

    # All good, return standard 0 exit code
    return 0
}
