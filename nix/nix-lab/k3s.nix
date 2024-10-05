{ hostConf, ... }: {
  services.k3s = {
    enable = true;
    role = "server";
    token = "AZAwcp1K7ZBx45yk";
    extraFlags = toString ([
      "--write-kubeconfig-mode \"0644\""
      "--cluster-init"
      "--disable servicelb"
      "--disable traefik"
      "--disable local-storage" ] ++ 
      (if hostConf.name == "bard" then [] else ["--server https://192.168.1.31:6443"])
    );
    clusterInit = (hostConf.name  == "bard");
  };
}