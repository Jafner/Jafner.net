{ inputs
, username
, system
, ...
}: {
  home-manager = {
    users."${username}" = {
      home.packages = [
        inputs.deploy-rs.packages."${system}".deploy-rs
        inputs.zen-browser.packages."${system}".default
      ];
    };
    backupFileExtension = "bk";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
      inputs.stylix.homeManagerModules.stylix
      inputs.chaotic.homeManagerModules.default
    ];
  };
}
