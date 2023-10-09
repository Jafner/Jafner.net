# takes a docker-compose.yml file path and returns a boolean to represent 
# whether that stack depends on an smb share under the `/mnt/nas` path
function uses_smb_share { 
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
function valid_compose {
    STACK_PATH=$1
    docker-compose config -f $STACK_PATH > /dev/null 2>&1 
    return $?
}

# takes a docker-compose.yml file path and shuts it down
function compose_down {
    STACK_PATH=$1
    docker-compose down -f $STACK_PATH
}

# takes a docker-compose.yml file path and brings it up
function compose_up {
    STACK_PATH=$1
    docker-compose up -f $STACK_PATH -d
}

# takes a docker-compose.yml file path and force recreates it
function compose_up_recreate {
    STACK_PATH=$1
    docker-compose up -d --force-recreate -f $STACK_PATH
}

function main {
    echo "\$OPERATION is $OPERATION"
    echo "Parse global flags"
    while [ $# -gt 0 ]; do
        case $1 in
            -n | --nas-only)
                NASONLY=true
            ;;
            -l | --lint)
                LINT=true
            ;;
            *)
                OPERATION="$OPERATION $1"
            ;;
        esac
        shift
    done
    echo "\$OPERATION is $OPERATION"
    echo "Determine operation"
    case $OPERATION in
      up*)
        while [ $# -gt 0 ]; do
            case $1 in
                -f | --force)
                    FORCE=true
                ;;
                up)
                    true
                ;;
                *)
                    echo "Unrecognized operation \'$1\'"
                    exit
                ;;
            esac
            shift
        done
        echo "FORCE is $FORCE"
      ;;
      down*)
        while [ $# -gt 0 ]; do
            case $1 in
                down)
                    true
                ;;
                *)
                    echo "Unrecognized operation \'$1\'"
                    exit
                ;;
            esac
            shift
        done
        echo "FORCE is $FORCE"
      ;;
      *)
        echo "Operation not recognized."
        exit
      ;;
    esac
}

main "$@"