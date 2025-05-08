# Jafner.net
A monorepo for all my projects and dotfiles. Hosted on [GitHub](https://github.com/Jafner/Jafner.net).

## Map of Contents

| Project                | Summary |
|:----------------------:|:-------:|
| [hosts](hosts/) | Host-specific documentation and configuration. |
| [modules](modules/) | Custom NixOS modules. |
| [nixosConfigurations](nixosConfigurations) | Configurations for NixOS systems. |
| [pkgs](pkgs/) | Scripts and programs packaged with Nix. |
| [sites/Jafner.dev](sites/Jafner.dev/)       | Static site files for Jafner.dev. |
| [.github/workflows](.github/workflows/) | GitHub Actions workflows |
| [.sops](.sops/) | Scripts and documentation implementing [sops](https://github.com/getsops/sops) to securely store secrets in this repo. |

## Flake.nix
This repo is centered on [flake.nix](flake.nix). You can list its outputs with: `nix flake show github:Jafner/Jafner.net`

## LICENSE: MIT License
> See [LICENSE](LICENSE) for details.

## Contributing
Presently this project is a one-man operation with no external contributors. All contributions will be addressed in good faith on a best-effort basis.
