# Goal
Spin up a Git server with a greater feature set than Gitea. 
Specifically, I want:
    - Integrated CI/CD. I would prefer a platform that comes with a 1st party CI/CD solution, rather than plugging in a 3rd party solution.
    - Container/image registry. Building a locally-hosted registry for images enables better caching.
    - Enterprise-competitive platform. Getting experience with a platform that competes with other enterprise SCM solutions is more valuable than something designed for a smaller scale.

# Plan
1. Create the host mount points for the docker volumes: `mkdir -p ~/docker_data/gitlab/data ~/docker_data/gitlab/logs ~/docker_config/gitlab/config`
2. Import the default GitLab configuration from [the docs](https://docs.gitlab.com/ee/install/docker.html#install-gitlab-using-docker-compose).
3. Customize the compose file:
    1. `hostname: gitlab.jafner.net`
    2. change the `external_url` under the `GITLAB_OMNIBUS_CONFIG` env var to `https://gitlab.jafner.net`
    3. Add the `gitlab_rails['gitlab_shell_ssh_port'] = 2229` configuration line under `GITLAB_OMNIBUS_CONFIG` with a new SSH port
    4. Remove http and https port bindings. Move host SSH port binding to a higher port.
    5. Change the volume bindings to match my conventions (`DOCKER_DATA` instead of `GITLAB_HOME`)
    6. Change the docker compose version to `'3.3'`
    7. Add Traefik labels to enable TLS.
4. Run the file and test.
5. Troubleshoot issues.
6. GOTO 4.
7. Import Gitea repos
8. Move Gitea from `git.jafner.net` to `gitea.jafner.net`
9. Update Homer with new service locations


===

# References

1. [GitLab Docker images](https://docs.gitlab.com/ee/install/docker.html)
2. [GitLab SaaS vs Self-hosted](https://about.gitlab.com/handbook/marketing/strategic-marketing/dot-com-vs-self-managed/)
3. [Digital Ocean: How to Setup GitLab on a Digital Ocean Droplet](https://www.digitalocean.com/community/tutorials/how-to-setup-gitlab-a-self-hosted-github)