{ pkgs, lib, username, ... }:
{
 specialisation.bleeding-edge.configuration = {
   #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-rc; # Not sure why this doesn't build.
   services.scx = {
     enable = true;
     package = pkgs.scx_git.full;
     scheduler = "scx_lavd";
   };
   chaotic.mesa-git.enable = true;
   home-manager.users.${username} = {
     home.packages = with pkgs; [
       latencyflex-vulkan
     ];
     programs.zed-editor.package = pkgs.zed-editor_git;
     programs.mangohud.package = pkgs.mangohud_git;
   };
 };
}
