{ sys, pkgs, inputs, flake, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ]; 
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    #age.keyFile = "/home/${sys.username}/.config/sops/age/keys.txt"; # This file is expected to be provided from outside the nix-store
    age.generateKey = false;
  };

  home-manager.users.${sys.username}.home.packages = with pkgs; [
    sops
    age
    ssh-to-age
    ( writeShellApplication {
        name = "sops-nix";
        runtimeInputs = [ git ssh-to-age openssh yq  ];
        text = ''
          #! bash

          # shellcheck disable=SC2002
          # shellcheck disable=SC2016

          REPO_ROOT="/home/${sys.username}/${flake.repoPath}"
          # shellcheck disable=SC2034
          SOPS_AGE_KEY_FILE="/home/${sys.username}/.config/sops/age/keys.txt"

          listSecrets () {
            # shellcheck disable=SC2002
            SOPS_REGEX="$(cat "$REPO_ROOT/.sops.yaml" | yq -y '.creation_rules.[].path_regex' | head -n1)"
            find "$REPO_ROOT" -regextype posix-extended -regex "$SOPS_REGEX"
          }

          getPubkey () {
            ADDRESS="$1"
            AGE_PUBKEY="$(ssh-keyscan -t ed25519 "$ADDRESS" | ssh-to-age)"
            echo "$AGE_PUBKEY"
          }

          addPubkey () { # Note: Does not edit any files. Prints .sops.yaml with the given key added.
            AGE_PUBKEY="$1"
            # shellcheck disable=SC2002,SC2016
            cat "$REPO_ROOT"/.sops.yaml |\
            yq -y --arg key "$AGE_PUBKEY" '.keys += [$key]' |\
            yq -y --arg key "$AGE_PUBKEY" '.creation_rules.[].key_groups.[].age += [$key]'
          }

          updateKey () { # Note: Interactive
            sops updatekeys --input-type json "$1"
          }

          encryptFile () { # Note: All encrypted files are in json format
            FILE="$1"
            FILE_EXT="''$''\{FILE##*.}"
            case "$FILE_EXT" in
              "env") FILE_TYPE=dotenv ;;
              "json") FILE_TYPE=json ;;
              "yaml|yml") FILE_TYPE=yaml ;;
              "ini") FILE_TYPE=ini ;;
              *) FILE_TYPE=binary ;;
            esac
            sops --encrypt --config "$REPO_ROOT/.sops.yaml" --input-type "$FILE_TYPE" --output-type json "$FILE"
          }

          decryptFile () { # Note: All encrypted files are in json format. 
                           # File extension is used as the hint for decrypted file type.
            FILE="$1"
            FILE_EXT="''$''\{FILE##*.}"
            case "$FILE_EXT" in
              "env") FILE_TYPE=dotenv ;;
              "json") FILE_TYPE=json ;;
              "yaml|yml") FILE_TYPE=yaml ;;
              "ini") FILE_TYPE=ini ;;
              *) FILE_TYPE=binary ;;
            esac
            sops --decrypt --config "$REPO_ROOT/.sops.yaml" --input-type json --output-type "$FILE_TYPE" "$FILE"
          }

          isJson () {
            FILE="$1"
            jq -e . >/dev/null 2>&1 <<<"$(cat "$FILE")" && return 0 || return 1;
          }

          isEncrypted () {
            FILE="$1"
            FILE_EXT="''$''\{FILE##*.}"
            case "$FILE_EXT" in
              "env") FILE_TYPE=dotenv ;;
              "json") FILE_TYPE=json ;;
              "yaml|yml") FILE_TYPE=yaml ;;
              "ini") FILE_TYPE=ini ;;
              *) FILE_TYPE=binary ;;
            esac
            if isJson "$FILE" && [[ "$(sops filestatus "$FILE")" == '{"encrypted":true}' ]]; then echo True; else echo False; fi
          }

          listSecretStatus () {
            for file in $(listSecrets); do 
              FILE="$(realpath -s --relative-to="$REPO_ROOT" "$file")"
              echo -n "$FILE: " |\
                xargs echo -n
              if sops --decrypt --input-type json "$file" >/dev/null 2>&1; then 
                echo Decryptable
              else 
                echo "Not decryptable"
              fi
            done
          }

          "$@"
        '';
      } )
  ];
}