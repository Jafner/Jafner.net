# .bashrc

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
source $SCRIPT_PATH/.shellrc
source $SCRIPT_PATH/.aliases

# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi