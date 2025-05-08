{ inputs
, username
, system
, ...
}: {
  home-manager = {
    users."${username}" = {
      home.packages = [
        inputs.deploy-rs.packages."${system}".deploy-rs
      ];
    };
    backupFileExtension = "bk";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
    ];
  };
}
