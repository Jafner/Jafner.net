{ username
, pkgs
, ...
}: {
  home-manager.users.${username} = {
    # Configure secrets-related parameters in the environment
    #   I wish aichat supported a more secure approach.
    #   See: https://github.com/sigoden/aichat/issues/802
    programs.zsh.envExtra = ''
      export JINA_API_KEY=$(cat /home/${username}/.keys/jina/aichat)
    '';
    programs.zsh.shellAliases = {
      aichat = "AICHAT_PLATFORM=openrouter OPENROUTER_API_KEY=$(rbw get openrouter --field aichat) aichat";
    };
    home.packages = with pkgs; [ repomix ];
    home.file = {
      "aichat/config.yaml" = {
        source = ./config.yaml;
        target = ".config/aichat/config.yaml";
      };
      "aichat/rag.yaml" = {
        text = ''
          # Config for aichat
          # https://github.com/sigoden/aichat

          rag_embedding_model: ollama:nomic-embed-text
          rag_reranked_model: null
          rag_top_k: 5
          rag_chunk_size: null
          rag_chunk_overlap: null
          rag_template: |
            Answer the query based on the context while respecting the rules. (user query, some textual context and r>

              <context>
              __CONTEXT__
              </context>

            <rules>
            - If you don't know, just say so.
            - If you are not sure, ask for clarification.
            - Answer in the same language as the user query.
            - If the context appears unreadable or of poor quality, tell the user then answer as best as you can.
            - If the answer is not in the context but you think you know the answer, explain that to the user then an>
            - Answer directly and without using xml tags.
            </rules>

            <user_query>
            __INPUT__
            </user_query>

          document_loaders:
            pdf: "${pkgs.python312Packages.pdftotext}/bin/pdftotext $1 -"
            docx: "${pkgs.pandoc}/bin/pandoc --to-plain $1"
            git: >
              sh -c "${pkgs.yek}/bin/yek $1 --json | ${pkgs.jq}/bin/jq '[.[] | { path: .filename, contents: .content }]'"
        '';
        target = ".config/aichat/rag.yaml";
      };
    };
  };
}
