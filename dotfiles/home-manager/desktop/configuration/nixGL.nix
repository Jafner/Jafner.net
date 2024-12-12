{ ... }: {
  nixGL = {
    vulkan.enable = true;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };
}