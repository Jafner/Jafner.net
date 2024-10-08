function initialize {
    USER="admin"
    HOSTNAME=$(hostname)
    STACKS_DIRECTORY="/home/$USER/homelab/$HOSTNAME/config"

    echo "Initialized with:"
    echo "USER=$USER"
    echo "HOSTNAME=$HOSTNAME"
    echo "STACKS_DIRECTORY=$STACKS_DIRECTORY"
}

function main {
    while [[ $# -gt 0 ]]; do
        case $1 in
            # parse global flags
            -n|--nas-only) NAS_ONLY=true; shift ;;
            -l|--lint) LINT=true; shift ;;
            -p|--path) STACKS_DIRECTORY="$2"; shift; shift ;;
            -v|--verbose) VERBOSE=true; shift ;;
            # parse command
            up*) COMMAND="docker-compose up -d"; shift;
                while [[ $# -gt 0 ]]; do
                    case $1 in
                        -f|--force-recreate) COMMAND="$COMMAND --force-recreate"; shift;;
                        *) echo "Unrecognized option '$1' for '$COMMAND'"; exit 1;;
                    esac
                done 
            ;;
            down*) COMMAND="docker-compose down"; shift; 
                while [[ $# -gt 0 ]]; do
                    case $1 in
                        -o|--remove-orphans) COMMAND="$COMMAND --remove-orphans"; shift;;
                        *) echo "Unrecognized option '$1' for '$COMMAND'"; exit 1;;
                    esac
                done
            ;;
            config*) COMMAND="docker-compose config"; shift;
                while [[ $# -gt 0 ]]; do
                    case $1 in
                        -n|--no-interpolate) COMMAND="$COMMAND --no-interpolate"; shift;;
                        *) echo "Unrecognized option '$1' for '$COMMAND'"; exit 1;;
                    esac
                done
            ;;
            *) echo "Unrecognized option $1"; exit 1 ;;
        esac
    done

    if [ -z ${COMMAND+x} ]; then
        echo "Error: no command specified"
        exit 1
    fi

    for stack in "$STACKS_DIRECTORY"/* ; do
        cd $stack
        if [ $NAS_ONLY ] || [ $LINT ]; then
            TMP=$(docker-compose config)
            PASS=$?
            if [ $PASS != 0 ]; then
                echo "ERROR: $stack failed to lint"
                continue
            fi
            if [ $NAS_ONLY ]; then
                echo $TMP | grep -q /mnt/nas
                NAS_DEPENDENT=$?
                if [ $NAS_DEPENDENT == 1 ]; then
                    continue
                fi
            fi
        fi

        echo "${PWD} $COMMAND"
    done
}

initialize
main "$@"