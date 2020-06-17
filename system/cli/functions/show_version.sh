#!/usr/bin/env bash

# Shows the current project version
#
# Usage:
# show_version
#
# Outputs:
# The value at key
function show_version(){
    get_json_value_file $APP_ROOT/composer.json version
}
