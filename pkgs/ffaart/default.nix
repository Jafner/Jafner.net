{ pkgs, ... }: {
  name = "ffaart";
  runtimeInputs = [
    pkgs.ffmpeg-full
  ];
  text = builtins.readFile ./ffaart.sh;
}
