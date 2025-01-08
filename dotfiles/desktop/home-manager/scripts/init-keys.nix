{ pkgs, ... }: {
  home.packages = with pkgs; [
    ( writeShellApplication {
      name = "init-keys";
      runtimeInputs = [
          ssh-to-age
      ];
      text = ''
        #!/bin/bash

        # Asserts all keys are where they belong.

        assert() {
          TEST_FILE="$1"
          FILE_HASH="$2"

          if [ ! -f "$1" ]; then
            echo "Error: Missing file $1"
            exit 1
          fi

          TEST_HASH="$(sha256sum "$TEST_FILE" | cut -d' ' -f1)"
          if [ ! "$HASH" == "$FILE_HASH" ]; then
            echo "Error: File hash mismatch $1"
            exit 1
          fi
          }
      '';
    } )
  ];
}
