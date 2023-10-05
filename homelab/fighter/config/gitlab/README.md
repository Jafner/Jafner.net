# Updating GitLab configuration
This gitlab instance is using the omnibus package. 
See [GitLab Omnibus Reconfigure](https://docs.gitlab.com/ee/administration/restart_gitlab.html#omnibus-gitlab-reconfigure) for official docs on reconfiguration. 
Here are the basic steps:
1. Update the `GITLAB_OMNIBUS_CONFIG` environment variable in `docker-compose.yml`. Add the desired omnibus configuration lines.
2. Run `docker exec -it gitlab_gitlab vi /etc/gitlab/gitlab.rb` to begin editing the omnibus config file. Make the necessary changes (`i` to enter insert mode), then save (`esc`, then `:wq`, enter).
3. Run `docker exec gitlab_gitlab gitlab-ctl diff-config` to compare the new config file with the *default* config file (not previous). The lines with `+` are from the default config, and the lines with `-` are the config to be applied.
4. Run `docker exec gitlab_gitlab gitlab-ctl reconfigure` to apply the changes. 
5. Confirm the value set in step 1 is still correct.

# View current GitLab configuration
To get the current Gitlab config, run `docker exec gitlab_gitlab cat /etc/gitlab/gitlab.rb`.  
You can also pipe this into `grep` to find the lines referring to a particular topic. For example: `docker exec gitlab_gitlab cat /etc/gitlab/gitlab.rb | grep registry`