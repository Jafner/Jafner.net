# Cloning the repository
1. Get the SSH key. Save the content of the `.ssh/id_rsa` file to `~/.ssh/id_rsa`
2. Restrict the permissions for the file with `chmod 600 ~/.ssh/id_rsa`
3. Add the key to the agent:
```bash
eval $(ssh-agent -s) && \
ssh-add ~/.ssh/id_rsa
```
4. Clone the repo with `git clone git@github.com:Jafner/dotfiles.git ~/Git/dotfiles`
5. Place the dotfiles where they need to be with `chmod +x install_dotfiles.sh && ./install_dotfiles.sh`
