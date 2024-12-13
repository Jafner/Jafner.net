{ pkgs, vars, ... }: {
  home.packages = with pkgs; [
    ssh-to-age
    pinentry-all
    ( writeShellApplication {
      name = "keyman";
      runtimeInputs = [];
      text = ''
      #!/bin/bash

      # Fuck GPG. Miserable UX.
      
      id="joey@jafner.net"
      device="desktop"
      homedir="/home/${vars.user.username}/.gpg"
      backupdir="/home/${vars.user.username}/.keys"
      mkdir -p "$homedir" "$backupdir"

      getPrimaryKeyFingerprint() {
        return "$(gpg --list-keys | grep fingerprint | tr -s ' ' | cut -d'=' -f2 | xargs)"
      }

      bootstrap() {
        gpg --quick-generate-key 'Joey Hafner <joey@jafner.net>' ed25519 cert 0
        gpg --quick-add-key "$(getPrimaryKeyFingerprint)" ed25519 sign 0
        gpg --quick-add-key "$(getPrimaryKeyFingerprint)" cv25519 encrypt 0
      }

      lockPrimary() {
        gpg -a --export-secret-key "$(getPrimaryKeyFingerprint)" > "$backupdir/$id.primary.gpg"
        gpg -a --export "$(getPrimaryKeyFingerprint)" > "$backupdir/$id.primary.gpg.pub"
        gpg -a --export-secret-subkeys "$(getPrimaryKeyFingerprint)" > "/tmp/subkeys.gpg"
        gpg --delete-secret-subkeys "$(getPrimaryKeyFingerprint)" 
        gpg --import "/tmp/subkeys.gpg" && rm "/tmp/subkeys.gpg"
      }

      unlockPrimary() {
        gpg --import "$backupdir/$id.primary.gpg"
        if gpg --list-secret-keys | grep -q sec#; then 
          echo "Unlocked primary key $backupdir/$id.primary.gpg"
        else
          echo "Failed to unlock primary key $backupdir/$id.primary.gpg"
        fi
      }

      initNewDevice() {
        stty icrnl
        unlockPrimary
        gpg --quick-add-key "$(getPrimaryKeyFingerprint)" ed25519 sign 0
        if [[ $(gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]") -gt 1 ]]; then
          echo "More than one loaded signing key is listed for today's date. Please select one:"
          while read -r key; do 
            key_list+=( "$key" )
          done< <(gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]")
          select key in "''$''\{key_list[@]}"; do 
            SUBKEY_FINGERPRINT=$(echo "$key" | cut -d'/' -f2 | cut -d' ' -f1)
            export SUBKEY_FINGERPRINT
            echo "Subkey fingerprint: $SUBKEY_FINGERPRINT"
            break
          done
        else
          SUBKEY_FINGERPRINT=$(gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]" | cut -d'/' -f2 | cut -d' ' -f1 | head -1)
          export SUBKEY_FINGERPRINT
        fi
        gpg --list-keys | grep "$(date +%Y-%m-%d)" | grep "[S]"
        gpg -a --export-secret-key "$SUBKEY_FINGERPRINT" > "$backupdir/$id.$device.gpg"
        gpg -a --export "$SUBKEY_FINGERPRINT" > "$backupdir/$id.$device.gpg.pub"

        lockPrimary
      }

      "$@" || declare -F

      '';
    } )
  ];

  programs.gpg = {
    enable = true;
    homedir = "/home/${vars.user.username}/.gpg";
    mutableKeys = true;
    mutableTrust = true;
    publicKeys = [
      #{ source = ../../../pubkeys/gpg/joey.desktop@jafner.net; }
    ];
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableScDaemon = false;
    pinentryPackage = pkgs.pinentry-qt;
  };

  home.file."profiles" = {
    target = ".ssh/profiles";
    text = ''
    admin@192.168.1.31
    admin@192.168.1.32
    admin@192.168.1.33
    admin@192.168.1.10
    admin@192.168.1.11
    admin@192.168.1.12
    vyos@192.168.1.1
    admin@192.168.1.23
    admin@143.110.151.123
    '';
  };
  home.file."config" = {
    target = ".ssh/config";
    text = ''
      Host *
        ForwardAgent yes
        IdentityFile ~/.ssh/${vars.desktop.sshKey}
  '';
  };
  home.file."authorized_keys" = {
    target = ".ssh/authorized_keys";
    text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9guFiLtbnUn93C3fBggGFyPqR3/5pPKrVTtuGL/dcP joey@pixel
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzxkV2KZDEUKddI2sbgpQkYFazRSmt/XfzVhcHHDGso joey@joey-laptop
    '';
  };
}
