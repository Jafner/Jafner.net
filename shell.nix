# Install core packages, configure toolkits
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

  pkgs.mkShellNoCC {
    packages = with pkgs; [
      ssh git sops docker
      vim
      tree btop
      bat fd eza fzf
      ssh-to-age
    ];
    shellHook = ''
      # Configure env
      USER="joey"
      HOSTNAME="dungeon-master"
      NAME="Joey Hafner"
      EMAIL="joey@jafner.net"

      # Configure SSH. Expects existing key at ~/.ssh/$USER@$HOSTNAME.key
      SSH_KEY="~/.ssh/$USER@$HOSTNAME.key"
      SSH_PUBKEY="~/.ssh/$USER@$HOSTNAME.pub"
      alias ssh="ssh -i $SSH_KEY"

      # Configure Git
      # global
      git config core.sshcommand "ssh -i $SSH_KEY"
      git config user.name "$NAME"
      git config user.email "$EMAIL"
      git config user.signingkey "$SSH_PUBKEY"
      git config init.defaultbranch "main"
      git config gpg.format "ssh"
      git config commit.gpgsign "true"
      git config credential.helper "manager"
      git config core.pager "delta"
      git config delta.side-by-side "true"
      git config interactive.difffilter "delta --color-only"
      
      # repo
      git config core.repositoryformatversion "0"
      git config core.filemode "true"
      git config core.bare "false"
      git config core.logallrefupdates "true"
      git config remote.origin.url "ssh://git@gitea.jafner.tools:2225/Jafner/Jafner.net.git"
      git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
      git config branch.main.remote "origin"
      git config branch.main.merge "refs/heads/main"
      git config submodule.sites/Jafner.dev/themes/hello-friend-ng.active "true"
      git config submodule.sites/Jafner.dev/themes/hello-friend-ng.url "https://github.com/rhazdon/hugo-theme-hello-friend-ng.git"
      
      # Configure sops
      ssh-2-age -p -i $SSH_KEY $HOME/.age/key 
      git config filter.sops.smudge '.sops/decrypt-filter.sh %f'
      git config filter.sops.clean '.sops/encrypt-filter.sh %f'
      git config filter.sops.required "true"

    '';

};

