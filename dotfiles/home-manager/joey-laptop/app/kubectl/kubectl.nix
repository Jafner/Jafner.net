{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    k3s 
    kubernetes-helm 
    helmfile-wrapped  ];
}