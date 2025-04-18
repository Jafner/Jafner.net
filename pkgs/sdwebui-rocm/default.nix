{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  name = "sdwebui-rocm";
  src = pkgs.dockerTools.buildImage {
    name = "sdwebui-rocm";
    tag = "dev";
    fromImage = pkgs.dockerTools.pullImage {
      imageName = "rocm/pytorch";
      imageDigest = "sha256:05b55983e5154f46e7441897d0908d79877370adca4d1fff4899d9539d6c4969"; # 2025-04-06_00:44
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      finalImageTag = "latest";
      finalImageName = "pytorch";
    };
    contents = [ ./bootstrap.sh ];
    runAsRoot = ''
      apt update && apt upgrade -y && apt dist-upgrade -y && apt install google-perftools libgoogle-perftools-dev -y
      echo 'PATH=/usr/local/bin:$PATH' >> /etc/bash.bashrc
      PATH=/usr/local/bin:$PATH
      adduser -u 1001 --disabled-password --gecos "" dockerx
    '';
    config = {
      User = "dockerx";
      Env = [ "HIP_VISIBLE_DEVICES=0" ];
      WorkingDir = "/dockerx";
      Cmd = [ "./bootstrap.sh" ];
    };
  };
  buildInputs = with pkgs; [
    docker
  ];
}
