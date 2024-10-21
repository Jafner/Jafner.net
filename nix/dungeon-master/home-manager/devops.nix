{ pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform
    sops ssh-to-age age
    doctl
    k3s 
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
        helm-secrets
        helm-s3
        helm-git
      ];
    })
    helmfile-wrapped
  ];
}