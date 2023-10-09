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
    while [ $# -gt 0 ]; do
        case $1 in
            -n | --nas-only)
                NASONLY=true
            ;;
        esac
        shift
    done
    echo "\$@ is \"$@\""
    echo "\$NASONLY is $NASONLY"
}

main "$@"