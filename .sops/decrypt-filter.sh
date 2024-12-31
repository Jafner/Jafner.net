
# Takes file path as first positional argument
# Takes encrypted file contents from /dev/stdin
# Outputs to stdout

if [[ -f $HOME/.age/key ]]; then
    export SOPS_AGE_KEY_FILE=$HOME/.age/key
else
    echo "SOPS_AGE_KEY_FILE not found at $HOME/.age/key"
    echo "Cannot decrypt secrets."
    exit 1
fi

REPO_ROOT="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."
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
    sops --decrypt /dev/stdin
else
    sops --decrypt --input-type $FILE_TYPE --output-type $FILE_TYPE /dev/stdin
fi
