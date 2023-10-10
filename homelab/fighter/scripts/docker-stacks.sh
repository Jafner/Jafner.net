# takes a docker-compose.yml file path and returns a boolean to represent 
# whether that stack depends on an smb share under the `/mnt/nas` path
function check_nas { 
    STACK_PATH=$1
    docker-compose config -f $STACK_PATH | grep -q /mnt/nas
    MATCH=$?
    if [ $MATCH == 0]; then
        return true
    else
        return false
    fi
}

# takes a docker-compose.yml file path and returns a boolean to represent 
# whether that stack passes a docker-compose config lint
function lint {
    STACK_PATH=$1
    docker-compose config -f $STACK_PATH > /dev/null 2>&1 
    return $?
}

function compose_config {
    STACK_PATH=$1
    docker-compose config -f $STACK_PATH
}

# takes a docker-compose.yml file path and shuts it down
function compose_down {
    STACK_PATH=$1
    docker-compose down -f $STACK_PATH
}

# takes a docker-compose.yml file path and brings it up
function compose_up {
    STACK_PATH=$1
    if [ "$FORCERECREATE" = true ]; then
        docker-compose up --force-recreate -f $STACK_PATH -d
    elif [ "$FORCERECREATE" = false ]; then
        docker-compose up -f $STACK_PATH -d
    else
        echo "Bad variable value: \$FORCERECREATE=$FORCERECREATE"
    fi
}

function main {
    #echo "\$ARGS is $ARGS"
    STACKS_DIRECTORY="/home/admin/homelab/fighter/config"
    while [[ $# -gt 0 ]]; do
        #echo "case is $1"
        case $1 in
            # global flags are parsed first
            -n|--nas-only) NAS_ONLY=true; shift ;;
            -l|--lint) LINT=true; shift ;;
            -p|--path) STACKS_DIRECTORY="$2"; shift; shift ;;
            -v|--verbose) VERBOSE=true; shift ;;
            # commands are parsed with nested parsing for subcommand flags
            up*) COMMAND="up"; shift;
                while [[ $# -gt 0 ]]; do
                    case $1 in
                        -f|--force-recreate) FORCE_RECREATE=true; shift;;
                        *) echo "Unrecognized option '$1' for '$COMMAND'"; exit 1;;
                    esac
                done 
            ;;
            down*) COMMAND="down"; shift; 
                while [[ $# -gt 0 ]]; do
                    case $1 in
                        -o|--remove-orphans) REMOVE_ORPHANS=true; shift;;
                        *) echo "Unrecognized option '$1' for '$COMMAND'"; exit 1;;
                    esac
                done
            ;;
            config*) COMMAND="config"; shift;
                while [[ $# -gt 0 ]]; do
                    case $1 in
                        -n|--no-interpolate) NO_INTERPOLATE=true; shift;;
                        *) echo "Unrecognized option '$1' for '$COMMAND'"; exit 1;;
                    esac
                done
            ;;
            *) echo "Unrecognized option $1"; exit 1 ;;
        esac
    done

    for stack in "$STACKS_DIRECTORY"/* ; do
        case $COMMAND in
            up) echo "$COMMAND on $stack" ;;
            down) echo "$COMMAND on $stack" ;;
            config) compose_config $stack ;;
            *) echo "Unrecognized command '$COMMAND'" ;;
        esac
    done
}

ARGS="$@"

main $ARGS