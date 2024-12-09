{ pkgs, vars, ... }: {
  home.packages = with pkgs; [
    ollama-rocm
    ( writeShellApplication {  
      name = "ollama-quick-chat"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
      runtimeInputs = [
        libnotify
      ];
      text = ''
        #!/bin/bash
        MODEL=''$''\{1:-""}

        if [ -z "''$''\{MODEL}" ]; then          
          echo "No model selected. Choose a model from the list below:"
          unset modellist
          while read -r model; do 
            modellist+=( "$model" )
          done< <(${pkgs.ollama-rocm}/bin/ollama list | tail -n+2)
          select model in "''$''\{modellist[@]}"; do 
            MODEL=$(echo "$model" | tr -s ' ' | cut -d' ' -f1)
            echo "Selected: $MODEL"
            export MODEL
            break
          done
        fi

        echo "Loading model $MODEL"
        ${pkgs.ollama-rocm}/bin/ollama run "$MODEL" ""
        echo "Finished loading $MODEL"

        ${pkgs.ollama-rocm}/bin/ollama run "$MODEL"

        echo "Unloading model $MODEL"
        ${pkgs.ollama-rocm}/bin/ollama stop "$MODEL"
      '';
    } )
  ];
  
  xdg.desktopEntries.ollama = {
    exec = "kitty-popup ollama-quick-chat";
    icon = "/home/${vars.user.username}/.icons/custom/ollama.png"; 
    name = "AI Chat";
    categories = [ "Utility" ]; 
    type = "Application";
  };

  home.file."ollama.png" = {
    target = ".icons/custom/ollama.png";
    source = pkgs.fetchurl {
      url = "https://ollama.com/public/icon-64x64.png";
      sha256 = "sha256-jzjt+wB9e3TwPSrXpXwCPapngDF5WtEYNt9ZOXB2Sgs=";
    };
  };

  home.file."assistant.Modelfile" = {
    target = ".ollama/assistant.Modelfile";
    text = ''
    FROM llama3.2
    SYSTEM You are an assistant specialized in providing concise answers to prompts. Your answers should never be longer than 300 words. If the user asks a question with a complex answer, use references to outside resources such as specialized wikis to direct the user toward the answer to their question.
    '';
  };

  home.file."custom.Modelfile" = {
    enable = true;
    target = ".ollama/custom.Modelfile";
    text = ''
    FROM /home/joey/.llm/models/my-model.gguf
    '';
  };
}