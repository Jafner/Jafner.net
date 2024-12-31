
# Takes file path as $1
# Takes file contents from stdin
# Outputs to stdout

REPO_ROOT="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

export SOPS_AGE_KEY_FILE="$REPO_ROOT/.sops/$USER.author.key"

# Set input/output type
FILE_EXT="${1##*.}"

case $FILE_EXT in
    "env")
        FILE_TYPE=dotenv ;;
    "json")
        FILE_TYPE=json ;;
    "yaml")
        FILE_TYPE=yaml ;;
    "ini")
        FILE_TYPE=ini ;;
esac

if [[ -z ${FILE_TYPE+x} ]]; then
    sops --encrypt --config $REPO_ROOT/.sops.yaml /dev/stdin
else
    sops --encrypt --config $REPO_ROOT/.sops.yaml --input-type $FILE_TYPE --output-type json /dev/stdin
fi
