#!/usr/bin/env bash
# Requires use of ./lib/util/format.sh if used outside of the application binary

# Outputs a standardised error message
#
# Usage:
# error <message>
# error <label> <message>
function error() {
    if [[ $# -eq 1 ]]; then
        message "${RED}" "Error" "$1"
    elif [[ $# -eq 2 ]]; then
        message "${RED}" "$1" "$2"
    else
        error "Internal Error" "Malformed call to error"
    fi
}


# Outputs a standardised notice message
#
# Usage:
# notice <message>
# notice <label> <message>
function notice() {
    if [[ $# -eq 1 ]]; then
        message "${BLUE}" "Notice" "$1"
    elif [[ $# -eq 2 ]]; then
        message "${BLUE}" "$1" "$2"
    else
        error "Internal Error" "Malformed call to notice"
    fi
}

# Outputs a standardised success message
#
# Usage:
# success <message>
# success <label> <message>
function success() {
    if [[ $# -eq 1 ]]; then
        message "${GREEN}" "Success" "$1"
    elif [[ $# -eq 2 ]]; then
        message "${GREEN}" "$1" "$2"
    else
        error "Internal Error" "Malformed call to success"
    fi
}

# Outputs a standardised warning message
#
# Usage:
# warning <message>
# warning <label> <message>
function warning() {
    if [[ $# -eq 1 ]]; then
        message "${YELLOW}" "Warning" "$1"
    elif [[ $# -eq 2 ]]; then
        message "${YELLOW}" "$1" "$2"
    else
        error "Internal Error" "Malformed call to warninc"
    fi
}

# Outputs a formatted message
#
# Usage:
# message <color> <label> <message>
function message() {
   echo -e "${1}${2}:${RESET} $3"
}
