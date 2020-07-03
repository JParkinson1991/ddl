#!/usr/bin/env bash

# Determine search root
# Either provided as command argument or taken from APP_ENV environment variable
searchRoot=${1:-$APP_ROOT}

# Validate search root
# Ensure it could be determined from command argument or environment variables
if [[ -z "$searchRoot" ]]; then
    searchRoot="$PWD"
fi

# Provide output on what is being used as search root
notice "Searching" "$searchRoot"

# Find the php files
#foundFiles=$(ls -lR "$searchRoot" | grep --count \.php$)
fileSearchOutput=$(file_num_with_extension "$searchRoot" "php")
fileSearchExitCode=$?

# If file search error, out
if [[ $fileSearchExitCode -ne 0 ]]; then
    echo $fileSearchOutput
    exit $fileSearchExitCode
fi

# Output what was found
success "PHP Files" "$fileSearchOutput"

exit 0
