# Hyprland configuration as a flake

Below is a flake, using `example-hostname`, to show how to consume this remote flake.

> Refer to the schema here on the [NixOS wiki](https://nixos.wiki/wiki/Flakes#Output_schema)

```nix
{
  description = "example flake consuming this repo's remote flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-config = {
        url = "github:iancleary/hyprland-config;
        inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      specialArgs = { inherit inputs; };

      x86-system = "x86_64-linux";

    in
    {
      nixosConfigurations = {
        example-hostname = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            inputs.hyprland-config.nixosModules.nixos
            inputs.hyprland-config.nixosModules.home-manager
          ];
        };
      };
    };
}

```
