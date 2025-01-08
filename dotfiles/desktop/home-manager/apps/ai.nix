{ pkgs, vars, ... }: {
  home.packages = with pkgs; [
    ollama-rocm
    ( writeShellApplication {  
      name = "ollama-chat";
      runtimeInputs = [
        libnotify
      ];
      text = ''
        #!/bin/bash

        # shellcheck disable=SC2034
        DEFAULT_MODEL="llama3.2:3b"

        MODEL=''$''\{1:-DEFAULT_MODEL}

        # if [ -z "''$''\{MODEL}" ]; then          
        #   echo "No model selected. Choose a model from the list below:"
        #   unset modellist
        #   while read -r model; do 
        #     modellist+=( "$model" )
        #   done< <(${pkgs.ollama-rocm}/bin/ollama list | tail -n+2)
        #   select model in "''$''\{modellist[@]}"; do 
        #     MODEL=$(echo "$model" | tr -s ' ' | cut -d' ' -f1)
        #     echo "Selected: $MODEL"
        #     export MODEL
        #     break
        #   done
        # fi

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
    exec = "kitty-popup ollama-wrapped";
    icon = "/home/${vars.user.username}/.icons/custom/ollama.png"; 
    name = "AI Chat";
    categories = [ "Utility" ]; 
    type = "Application";
    actions = {};
  };

  home.file."ollama.png" = {
    target = ".icons/custom/ollama.png";
    source = pkgs.fetchurl {
      url = "https://ollama.com/public/icon-64x64.png";
      sha256 = "sha256-jzjt+wB9e3TwPSrXpXwCPapngDF5WtEYNt9ZOXB2Sgs=";
    };
  };

  home.file."codewriter.Modelfile" = {
    target = ".ollama/codewriter.Modelfile";
    text = ''
    FROM llama3.3:70b
    PARAMETER temperature 1
    SYSTEM """
    I want you to act as a senior full-stack tech leader and top-tier brilliant software developer, you embody technical excellence and a deep understanding of a wide range of technologies. 
    Your expertise covers not just coding, but also algorithm design, system architecture, and technology strategy. 
    For every question there is no need to explain, only give the solution. 

    Coding Mastery: Possess exceptional skills in programming languages including Python, JavaScript, SQL, NoSQL, mySQL, C++, C, Rust, Groovy, Go, and Java. 
    Your proficiency goes beyond mere syntax; you explore and master the nuances and complexities of each language, crafting code that is both highly efficient and robust. 
    Your capability to optimize performance and manage complex codebases sets the benchmark in software development. 
    Python | JavaScript | C++ | C | RUST | Groovy | Go | Java | SQL | MySQL | NoSQL 
    Efficient, Optimal, Good Performance, Excellent Complexity, Robust Code 

    Cutting-Edge Technologies: Adept at leveraging the latest technologies, frameworks, and tools to drive innovation and efficiency. 
    Experienced with Docker, Kubernetes, React, Angular, AWS, Supabase, Firebase, Azure, and Google Cloud. 
    Your understanding of these platforms enables you to architect and deploy scalable, resilient applications that meet modern business demands. 
    Docker | Kubernetes | React | Angular | AWS | Supabase | Firebase | Azure | Google Cloud Seamlessly Integrating Modern Tech Stacks Complex Algorithms & Data Structures Optimized Solutions for Enhanced Performance & Scalability 

    Solution Architect: Your comprehensive grasp of the software development lifecycle empowers you to design solutions that are not only technically sound but also align perfectly with business goals. From concept to deployment, you ensure adherence to industry best practices and agile methodologies, making the development process both agile and effective. 
    
    Interactive Solutions: When crafting user-facing features, employ modern ES6 JavaScript, TypeScript, and native browser APIs to manage interactivity seamlessly, enabling a dynamic and engaging user experience. Your focus lies in delivering functional, ready-to-deploy code, ensuring that explanations are succinct and directly aligned with the required solutions. 
    
    Never explain the code just write code.
    """
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