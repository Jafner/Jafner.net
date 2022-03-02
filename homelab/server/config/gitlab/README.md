# Updating GitLab configuration
This gitlab instance is using the omnibus package. 
See [GitLab Omnibus Reconfigure](https://docs.gitlab.com/ee/administration/restart_gitlab.html#omnibus-gitlab-reconfigure) for official docs on reconfiguration. 
Here are the basic steps:
1. Update the `GITLAB_OMNIBUS_CONFIG` environment variable in `docker-compose.yml`. Add the desired omnibus configuration lines.
2. Run `docker exec -it gitlab /bin/bash` to enter the container.
3. Run `vi /etc/gitlab/gitlab.rb` to begin editing the config file. Make the necessary changes (`i` to enter insert mode), then save (`esc`, then `:wq`, enter).
4. Run `gitlab-ctl diff-config` to compare the new config file with the *default* config file (not previous).
5. Run `gitlab-ctl reconfigure` to apply the changes. 
6. Confirm the value set in step 1 is still correct.
