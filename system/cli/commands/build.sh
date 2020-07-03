#!/usr/bin/env bash

# Flag warning if APP_ROOT not available
if [[ -z ${APP_ROOT} ]]; then
    warning "Failed to determine APP_ROOT"
fi

# Store custom option values
# BUILD_COMPILER_TAGS
#     An array of standard docker -t [tag] strings
#     Array imploded on compiler build command as needed
compilerImageTags=("-t ddl-compiler:latest")

# Parse custom options from argument string
standardArguments=()
while [[ $# -gt 0 ]]
do
    case "$1" in
        --compiler-tag)
            if [[ $2 != "ddl-compiler:latest" ]]; then
                compilerImageTags+=("-t $2")
            fi
            shift # past --compiler-tag
            shift # past argument
            ;;
        *)
			# Unhandled value treat it as a standard argument
	   		standardArguments+=("$1")
	    	shift # past argument
	    ;;
    esac
done
set -- "${standardArguments[@]}" # restore standard arguments to $@/$* etc

# Argument processing, complete, determine build context
# Build everything if no args provided, else only builds whats provided
buildAll=false
if [[ $# -eq 0 ]]; then
    buildAll=true
fi

# Store exit code, populate per build action
exitCode=0

# If building everything, or argument list contains the compiler service
# Build the compiler
if [[ "$buildAll" == true ]] || string_contains "$*" "compiler"; then
    # Remove compiler from the arguments
    for arg
    do
        shift
        if [[ "$arg" != "compiler" ]]; then
            set -- "$arg"
        fi
    done

    # If APP_ENV exists, create a build arg string, if not use default defined in compiler Dockerfile
    if [[ -n "$APP_ENV" ]]; then
        compilerBuildArg="--build-arg APP_ENV=$APP_ENV"
    fi

    docker build $compilerBuildArg ${compilerImageTags[*]} -f "$APP_ROOT/env/images/compiler/Dockerfile" "$APP_ROOT"

    # Store exit code, if not successful exit
    exitCode=$?
    if [[ $exitCode -ne 0 ]]; then
        exit $exitCode
    fi

    # Successful compiler build, copy out its cache if APP_ROOT can be determined
    # Only copy out cache if we know APP_ROOT to avoid addind directories to unknown locations within the host
    if [[ -n "${APP_ROOT}" ]]; then
        hostComposerCacheDir="${APP_ROOT}/var/cache/composer"

        # Create the cache dir as needed
        if [[ ! -d "$hostComposerCacheDir" ]]; then
            mkdir -p "$hostComposerCacheDir"
        fi

        # Export the cache, create a temp container from the built image, copy out the cache, delete the container
        notice "Exporting composer cache"
        compilerTempId=$(docker create ddl-compiler:latest)
        docker cp $compilerTempId:/tmp/cache/. "$hostComposerCacheDir"
        docker rm -v $compilerTempId
    fi
fi

# If building everything, or there are still services that need to be built
if [[ "$buildAll" == true ]] || [[ $# -gt 0 ]]; then
    docker-compose build $@
    exitCode=$?
fi

exit $exitCode;
