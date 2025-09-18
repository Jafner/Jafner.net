---
title: Tips and Tricks for NixOS Desktop in 2025
description: "An article describing patterns, workflows, and tools I've found useful for working with and around NixOS as my primary desktop."
date: 2025-06-18
updated: 2025-06-18
tags: nixos,gaming,desktop
slug: nixos-tips-and-tricks
---

## Tips and Tricks for NixOS Desktop in 2025

I've been using NixOS as my one and only desktop OS since September 2024. Since then, I've encountered plenty of challenges and obstacles. This article snapshots my experience working through (or around) many of the issues I've encountered while using NixOS as my desktop Linux distro.

## NixOS Configuration Patterns

### Flakes; Home-Manager; NixOS-Unstable

When I started using NixOS, there was no strong consensus about whether you should use flakes, if/how you should use home-manager, or which channel to use. After exploring a great swathe of the possible permutations, I've settled on the following:

#### Use Flakes

#### Install Home-Manager as a NixOS Module

#### Use the `nixos-unstable` Channel

- Use a flake.
- Use Home-Manager as a NixOS module (not a standalone install).
- Use the `nixos-unstable` channel.

### Store your SSH pubkey(s) in your flake

_Or piggyback on GitHub_

I needed to configure my `~/.ssh/authorized_keys`. For a long time, I used this snippet to dynamically update my keys at build-time from GitHub's `.keys` endpoint, which exposes the public SSH keys attached to your GitHub account. (I found this extremely helpful any time I needed to configure a new machine via local terminal. `curl https://github.com/Jafner.keys > ~/.ssh/authorized_keys` is very quick.)

```nix
users.users."${username}" = {
  isNormalUser = true;
  extraGroups = [ "networkmanager" "wheel" ];
  description = "${username}";
  openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
    url = "https://github.com/Jafner.keys";
    sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
  }));
};
```

Nowadays, I just store `keys.txt` at the root of my repo and replace the chunky part of that config with:

```nix
openssh.authorizedKeys.keys = ./keys.txt;
```

### Pass `username` to `specialArgs`

In the `let ... in ...` variable assignment block prepending my nixosConfiguration, I assign `username = joey`. It looks like this:

```nix
outputs = { ... }: {
  nixosConfigurations.desktop =
    let
      inherit inputs;
      username = "joey";
      ...
    in
    inputs.nixpkgs.lib.nixosSystem { ... };
}
```

And then to make that variable accessible from any module, I add `username` to `specialArgs` like this:

```nix
specialArgs = {
  inherit
    inputs
    username
    hostname
    system
  ;
};
```

And lastly, I use it like this:
`docker.nix`

```nix
{ username, ... }: {
  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
```

Or like this:
`audio.nix` snippet

```nix
{ pkgs, username, ... }: {
  home-manager.users."${username}" = {
    home.packages = with pkgs; [ goxlr-utility ];
  };
}
```

## Tools for Common Problems

### `nh` Nix Helper - Ergonomic CLI for managing your system

Plop a cute little snippet like this somewhere in your config:

```nix
programs.nh = {
  enable = true;
  flake = "/home/${username}/flake";
};
```

The config has to point at an existing flake.

I use: /home/${username}/Git/dotfiles
Could do: /home/${username}/dotfiles
Could do: /etc/flake

### `,` Comma - Run commands from packages you don't have installed

[nix-community/comma](https://github.com/nix-community/comma)
Comma in one hand and `nix-shell -p <package> --run <command>` in the other was all I needed to address NixOS innate inflexibility.

It's in Nixpkgs and doesn't need any configuration.

```nix
environment.systemPackages = [
  comma
];
```

### Sops Nix - Safely and securely include secrets in your NixOS code

[Mic92/sops-nix](https://github.com/Mic92/sops-nix)

### NixGL - Make OpenGL applications work as expected

[nix-community/nixGL](https://github.com/nix-community/nixGL)

## Common Nix/OS Usage Pitfalls

### Nix can only see files that are checked into Git

### Error: `dynamic attribute 'user' is already defined at ...`

[This issue](https://github.com/NixOS/nix/issues/916) is triggered when you have two or more configuration nodes _share a parent path that has a variable in it_.

To illustrate,
This one works:

```nix
home-manager.users.${username} = {
  home.packages = [ pkgs.nixd ];
  programs.zed-editor.enable = true;
};
```

This one breaks:

```nix
home-manager.users.${username}.home.packages = [ pkgs.nixd ];
home-manager.users.${username}.programs.zed-editor.enable = true;
```

Further, this one works:

```nix
home-manager.users.joey.home.packages = [ pkgs.nixd ];
home-manager.users.joey.programs.zed-editor.enable = true;
```

The workaround I prefer is to ensure that any home-manager configurations are structured like this:

```nix
home-manager.users.${username} = {
  ... my configuration ...
};
```

This issue does not occur when merging two files, only when evaluating a single file.
