

## This block checks all projects within the ~/homelab/jafner-net/config directory for NAS-dependence
NAS_DEPENDENTS=""
for project in $(find ~/homelab/jafner-net/config -maxdepth 1 -mindepth 1 -path ~/homelab/jafner-net/config/minecraft -prune -o -print | cut -d "/" -f7)
do
    echo "======== CHECKING $project ========"
    cd ~/homelab/jafner-net/config/$project
    docker-compose config | grep -q /mnt/nas
    MATCH=$?
    if [ $MATCH == 0 ]; then
        NAS_DEPENDENTS+="$project\n"
    fi
done

echo -e "$NAS_DEPENDENTS"

## This block runs docker-compose down for 
## all projects found by the previous block

for project in $(echo -e "$NAS_DEPENDENTS")
do
    echo "======== SHUTTING DOWN $project ========"
    cd ~/homelab/jafner-net/config/$project
    docker-compose down
done

# takes a docker-compose.yml file path and returns a boolean to represent 
# whether that stack depends on an smb share under the `/mnt/nas` path
function uses_smb_share () { 
    STACK_PATH=$1
    docker-compose config -f $STACK_PATH | grep -q /mnt/nas
    MATCH=$?
    if [ $MATCH == 0]; then
        return true
    else
        return false
    fi
}