# TODO
This page describes steps to take to move toward initial valid commit.

1. [X] Make list of constituent repositories.
2. [X] Commit all pending work on constituent repositories.
3. [X] Freeze all constituent repositories.
4. [X] Import constituent repositories with Git history.
5. [X] Reorganize repositories.
6. [X] Document organization.
7. [X] Scan for secrets.
8. [X] Initial commit.
9. [X] Consolidate duplicated repos.
10. [X] Differentiate active and inactive projects
    1.  `homelab`, `projects`, `blog`, `archive`
11. [X] Configure repo-level tools:
    1.  `.gitignore`
    2.  `.gitmodules`
    3.  `LICENSE`
    4.  `.github/workflows`
    5.  `.gitea/workflows`
    6.  `.pre-commit-config.yaml`
12. Cutover hosts from `homelab` to `Jafner.net` with sparse checkout.
    1.  `fighter` - Migrate secrets from `~/homelab/**/*_secrets.env` to `~/Jafner.net/active projects/homelab/**/*_secrets.env`. 
        - `cd /home/admin/homelab/ && SECRETFILES=$(find . -name '*_secrets.env' | cut -d'/' -f2-) && for file in $(echo $SECRETFILES); do FROM_FILE=$(echo "/home/admin/homelab/$file"); TO_FILE=$(echo "/home/admin/Jafner.net/homelab/$file"); echo "$FROM_FILE -> $TO_FILE"; cp -p "$FROM_FILE" "$TO_FILE"; done`
    2.  `druid`
13. Pin docker image versions to current.
14. Configure deployment systems
    1.  Github Pages for Jafner.dev
    2.  Push repo updates to `fighter` and `druid`
15. Write README.md that maps constituent projects.
16. Publish the repo.
17. Archive/annotate all constituent repos to point to subpath of new repo.

---

## Repositories
1. homelab [Gitea](https://gitea.jafner.tools/Jafner/homelab), [Github (docker_config)](https://github.com/Jafner/docker_config), [Github (wiki)](https://github.com/Jafner/wiki), [Github (cloud_tools)](https://github.com/Jafner/cloud_tools), [Github (self-hosting)](https://github.com/Jafner/self-hosting).
   - Rename? Jafner.net? Wouldn't that be `Jafner/Jafner.net/Jafner.net`? 
2. Jafner.dev [Github](https://github.com/Jafner/Jafner.dev).
3. dotfiles [Gitea](https://gitea.jafner.tools/Jafner/dotfiles), [Github](https://github.com/Jafner/dotfiles).
4. nvgm [Gitea](https://gitea.jafner.tools/Jafner/nvgm)
5. pamidi [Gitea](https://gitea.jafner.tools/Jafner/pamidi), [Github](https://github.com/Jafner/pamidi)
6. docker-llm-amd [Gitea](https://gitea.jafner.tools/Jafner/docker-llm-amd)
7. doradash [Gitea](https://gitea.jafner.tools/Jafner/doradash)
8. clip-it-and-ship-it [Gitea (PyClipIt)](https://gitea.jafner.tools/Jafner/PyClipIt), [Github](https://github.com/Jafner/clip-it-and-ship-it). 
9. razer battery led [Github](https://github.com/Jafner/Razer-BatteryLevelRGB)
10. 5etools-docker [Github](https://github.com/Jafner/5etools-docker)
11. jafner-homebrew [Github](https://github.com/Jafner/jafner-homebrew)

---

## Import Repositories
Below are described the steps taken to merge the many repositories listed above into one.

1. Install [`git-filter-repo`](https://github.com/newren/git-filter-repo): `curl -o ~/.local/bin/git-filter-repo https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo && chmod +x ~/.local/bin/git-filter-repo`
2. `git clone ssh://git@gitea.jafner.tools:2225/Jafner/homelab.git && cd homelab`
3. `git filter-repo --to-subdirectory-filter homelab`
4. Init a new empty git repository called `Jafner.net`: `cd ~/Git/Jafner.net && git init`
5. `mkdir homelab && cd homelab`
6. `git remote add homelab ssh://git@gitea.jafner.tools:2225/Jafner/homelab.git`
7. `git fetch homelab --tags`
8. `git merge --allow-unrelated-histories homelab/main`
9. `git remote remove homelab`

That's obviously a lot of steps to handle each repo manually, so let's script it.

```bash
#!/bin/bash

{
    echo "# 0. Quick reset: started"
    rm -rf $HOME/Git/Jafner.net
    rm -rf $HOME/Git/monorepo-temp  
    rm -rf /tmp/gitleaks 
    cd $HOME/Git
    echo "# 0. Quick reset: completed"
}

{
    echo "# 1. Configure paths and variables: started"
    echo "  # Configure local paths for Git repos. Should not contain any of the git directories involved, as all will be cloned fresh. Consider using a temporary project directory."
    MONOREPO_DIR=$HOME/Git/Jafner.net
    TEMP_CLONE_DIR=$HOME/Git/monorepo-temp
    mkdir -p "$TEMP_CLONE_DIR" 
    mkdir -p "$MONOREPO_DIR"
    echo "  # Configure array of repositories to compose into monorepo."
    echo "    # Note: First repository in list is parent monorepo."
    echo "    # Note: While we don't need write access to any of the constituent repositories, we do need authenticated access for any private repositories. Use ssh URLs when possible."
    REPOSITORIES=(
      "Jafner.net ssh://git@gitea.jafner.tools:2225/Jafner/Jafner.net.git"
      "homelab ssh://git@gitea.jafner.tools:2225/Jafner/homelab.git"
      "docker_config git@github.com:Jafner/docker_config.git"
      "wiki git@github.com:Jafner/wiki.git"
      "cloud_tools git@github.com:Jafner/cloud_tools.git"
      "self-hosting git@github.com:Jafner/self-hosting.git"
      "Jafner.dev git@github.com:Jafner/Jafner.dev.git"
      "dotfiles_gitea ssh://git@gitea.jafner.tools:2225/Jafner/dotfiles.git"
      "dotfiles_github git@github.com:Jafner/dotfiles.git"
      "nvgm ssh://git@gitea.jafner.tools:2225/Jafner/nvgm.git"
      "pamidi_gitea ssh://git@gitea.jafner.tools:2225/Jafner/pamidi.git"
      "pamidi_github git@github.com:Jafner/pamidi.git"
      "docker-llm-amd ssh://git@gitea.jafner.tools:2225/Jafner/docker-llm-amd.git"
      "doradash ssh://git@gitea.jafner.tools:2225/Jafner/doradash.git"
      "clip-it-and-ship-it git@github.com:Jafner/clip-it-and-ship-it.git"
      "PyClipIt ssh://git@gitea.jafner.tools:2225/Jafner/PyClipIt.git"
      "razer-bat git@github.com:Jafner/Razer-BatteryLevelRGB.git"
      "5etools-docker git@github.com:Jafner/5etools-docker.git"
      "jafner-homebrew git@github.com:Jafner/jafner-homebrew.git"
    )
    cd $TEMP_CLONE_DIR
    echo "# 1. Configure paths and variables: completed"
}

{ 
    echo "# 2. Assert dependencies are installed: started"
    echo -n "  # gitleaks: "
    gitleaks version > /dev/null 2>&1
    GITLEAKS_MISSING=$?
    if [[ $GITLEAKS_MISSING != "0" ]]; then
        echo "missing"
        echo "    # Attempting to install from https://github.com/gitleaks/gitleaks"
        echo "    # Installing at ~/.local/bin/gitleaks"
        echo "    # Note: Building gitleaks will fail if go is not installed."
        mkdir -p ~/.local/bin
        git clone https://github.com/gitleaks/gitleaks.git /tmp/gitleaks-git
        cd /tmp/gitleaks-git
        make build
        cp gitleaks ~/.local/bin/gitleaks
    else
        echo "found at $(which gitleaks)"
    fi
    echo -n "  # git-filter-repo: "
    git filter-repo -h > /dev/null 2>&1
    FILTER_REPO_MISSING=$?
    if [[ $FILTER_REPO_MISSING != "0" ]]; then
        echo "missing"
        echo "    # git-filter repo not installed. Attempting to install from https://github.com/newren/git-filter-repo" 
        echo "    # Installing at ~/.local/bin/git-filter-repo"
        mkdir -p ~/.local/bin/git-filter-repo
        curl -o ~/.local/bin/git-filter-repo https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo 
        chmod +x ~/.local/bin/git-filter-repo
    else
        echo "found at $(which git-filter-repo)"
    fi
    echo -n "  # BFG Repo-Cleaner: "
    bfg --version > /dev/null 2>&1
    BFG_MISSING=$?
    if [[ $BFG_MISSING != "0" ]]; then
        echo "missing"
        echo "    # Automated installation not yet implemented."
        echo "    # Install BFG Repo-Cleaner by downloading the latest jar from:"
        echo "    # https://rtyley.github.io/bfg-repo-cleaner/ "
        echo "    # Then run:"
        echo '    # sudo cp ~/Downloads/bfg.jar /usr/bin/bfg.jar && echo "java -jar /usr/bin/bfg.jar $@" | sudo tee /usr/bin/bfg && sudo chmod +x /usr/bin/bfg'
        echo "    # Exiting..."
        exit 1
    else
        echo "found at: $(which bfg)"
    fi
    echo "# 2. Assert dependencies are installed: completed"
}

{
    echo "# 3. Clone all constituent repositories, assert default branch is main: started"
    cd "$TEMP_CLONE_DIR"
    for repo in "${REPOSITORIES[@]:1}"; do 
        REPO_NAME=$(echo $repo | cut -d' ' -f1)
        echo "  # Cloning repo $REPO_NAME"
        git clone --quiet $(echo "$repo" | cut -d' ' -f2) "$REPO_NAME" > /dev/null
        cd "$REPO_NAME"
        DEFAULT_BRANCH=$(cat .git/HEAD | cut -d' ' -f2 | xargs basename)
        if ! [[ $DEFAULT_BRANCH == "main" ]]; then
            git branch -m $DEFAULT_BRANCH main
        fi
        cd "$TEMP_CLONE_DIR"
    done
    cd $TEMP_CLONE_DIR
    echo "# 3. Clone all constituent repositories, assert default branch is main: completed"
}

{
    echo "# 4. Rewrite history (to subdirectory) for each constituent repository: started"
    for repo in $(echo "$TEMP_CLONE_DIR"/*); do
        REPO_NAME=$(basename $repo)
        cd "$repo"
        echo "  # Rewriting repo $REPO_NAME"
        git filter-repo --quiet --to-subdirectory-filter "$REPO_NAME" --force > /dev/null
        cd "$TEMP_CLONE_DIR"
    done
    cd $TEMP_CLONE_DIR
    echo "# 4. Rewrite history (to subdirectory) for each constituent repository: completed"
}

{
    echo "# 5. Scan each constituent repository for leaked secrets: started"
    for repo in $(echo "$TEMP_CLONE_DIR"/*); do
        REPO_NAME=$(basename $repo)
        cd "$repo"
        mkdir -p /tmp/gitleaks/$REPO_NAME/
        echo -n "  # Scanning repo $REPO_NAME "
        rm -f /tmp/gitleaks/$REPO_NAME/gitleaks-report.json
        gitleaks detect -l warn --no-banner -r /tmp/gitleaks/$REPO_NAME/gitleaks-report.json && echo "No secrets detected" || COMPROMISED_REPOS+="$REPO_NAME\n" 
    done
    cd $TEMP_CLONE_DIR
    echo "# 5. Scan each constituent repository for leaked secrets: completed"
}

{
    echo "# 6. Nuke secrets from git history: started"
    for repo in $(echo "$TEMP_CLONE_DIR"/*); do
        cd $repo
        REPO_NAME=$(basename $repo)
        report=/tmp/gitleaks/$REPO_NAME/gitleaks-report.json
        if ! [[ $(cat $report | jq length) > 0 ]]; then
            echo "  # No exposed secrets in repo $REPO_NAME; Skipping."
            continue
        fi
        echo "  # Nuking secrets in repo $REPO_NAME"
        cat $report | jq -r '.[].Secret' > /tmp/gitleaks/secret.txt
        bfg --replace-text /tmp/gitleaks/secret.txt --no-blob-protection . 
        git reflog expire --expire=now --all && git gc --prune=now --aggressive
        cat /dev/urandom | tr -dc A-Za-z0-9 | head -c1000 > /tmp/gitleaks/secret.txt
        rm /tmp/gitleaks/secret.txt
    done
    cd $TEMP_CLONE_DIR
    echo "# 6. Nuke secrets from git history: completed"
}

{
    echo "# 7. Verify repository histories are clean of secrets: started"
    for repo in $(echo "$TEMP_CLONE_DIR"/*); do
        REPO_NAME=$(basename $repo)
        cd "$repo"
        mkdir -p /tmp/gitleaks/$REPO_NAME/
        echo -n "  # Scanning repo $REPO_NAME "
        rm -f /tmp/gitleaks/$REPO_NAME/gitleaks-report.json
        gitleaks detect -l warn --no-banner -r /tmp/gitleaks/$REPO_NAME/gitleaks-report.json && echo "No secrets detected" || echo "    # Something didn't work right; clean $REPO_NAME manually"
    done
    cd $TEMP_CLONE_DIR
    echo "# 7. Verify repository histories are clean of secrets: completed"
}

{
    echo "# 8. Init monorepo and add constituent repos: started"
    cd "$MONOREPO_DIR"
    git init
    for repo in $(echo "$TEMP_CLONE_DIR"/*); do 
        REPO_NAME=$(basename $repo)
        echo "Adding $REPO_NAME"
        git remote add "$REPO_NAME" "$repo"
        git fetch "$REPO_NAME" --tags
        git merge --quiet --allow-unrelated-histories -m "Merge $REPO_NAME into $(basename $MONOREPO_DIR)" "$REPO_NAME/main"
        git remote remove "$REPO_NAME"
    done
    echo "  # Running one more gitleaks scan for sanity."
    gitleaks detect -v --no-banner
    cd $TEMP_CLONE_DIR
    echo "# 8. Init monorepo and add constituent repos: completed"
}

{
    echo "############################################################"
    echo "#                                                          #"
    echo "# Next steps:                                              #"
    echo "# 1. Reorganize the repo to taste                          #"
    echo "# 2. Update repo-root configuration files such as:         #"
    echo "#    - .gitignore, .gitattributes, .gitmodules             #"
    echo "#    - .dockerignore, .pre-commit-config.yaml              #"
    echo "#    - .github/workflows, .gitlab-ci.yml, .gitea/workflows #"
    echo "#    - LICENSE, CONTRIBUTING, MAINTAINERS                  #"
    echo "# 3. Write a new root-level README.md                      #"
    echo "# 4. Add the remote repo as origin with:                   #"
    echo "#      git remote add origin <ssh URL of repo>             #"
    echo "# 5. Push the code to the Git server with:                 #"
    echo "#      git push --set-upstream origin main                 #"
    echo "#                                                          #"
    echo "############################################################"
}

```

---

## Scan for secrets
1. Install pre-commit: `pip install pre-commit`
2. Clone, build, install gitleaks: `cd ~/Git && git clone https://github.com/gitleaks/gitleaks.git && cd gitleaks && make build && cp gitleaks ~/.local/bin/`
3. Create [pre-commit config file](/.pre-commit-config.yaml).
4. Update and install pre-commit hooks: `pre-commit autoupdate && pre-commit install`
5. Generate baseline scan: `gitleaks detect -v -r gitleaks-report.json`

### `.pre-commit-config.yaml`
```yaml
repos:
-   repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.4
    hooks:
    -  id: gitleaks
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: check-yaml
```


From there we evaluate the report and remediate. I got a list of files with secrets via `cat gitleaks-report.json | jq -r 'keys[] as $k | "\($k), \(.[$k] | .File)"'`

We can use `git filter-repo` again to erase mention of any files containing secrets. 

`git filter-repo --invert-paths --path <path/to/file/with/secret>`

Reference: [GitHub docs - Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)


---

