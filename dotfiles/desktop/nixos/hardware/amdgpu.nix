{ pkgs, ... }: {
  boot.kernelModules = [ "amdgpu" "kvm-amd" ];
  hardware = {
    amdgpu.amdvlk.enable = false;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
}
