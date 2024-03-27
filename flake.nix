{
  description = "iancleary's Hyprland config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      specialArgs = { inherit inputs; };

      x86-system = "x86_64-linux";
      x86-pkgs = import nixpkgs {
        system = x86-system;
        config = {
          allowUnfree = true;
        };
      };

      hyprland-desktop-modules = [
        ./modules/desktop # folder
        ./modules/desktop/hyprland # folder
      ];

    in
    {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = x86-system;
          # pkgs = x86-pkgs;
          modules = common-modules ++ hyprland-desktop-modules ++ personal-modules
            ++ [
            ./hardware-configuration.nix # hardware-configuration/framework.nix
            ./configuration.nix # hosts/framework.nix
            ./home/iancleary-hyprland.nix
          ];
        };

        vm-iancleary-nixos = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = x86-system;
          modules = common-modules ++ gnome-desktop-modules ++ virtualbox-guest-modules
            ++ [
            ./hardware-configuration.nix # hardware-configuration/vm-iancleary-nixos.nix
            ./configuration.nix # hosts/vm-iancleary-nixos.nix
            ./home/iancleary-gnome.nix
          ];
        };
        vm-icleary-nixos = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = x86-system;
          modules = common-modules ++ xfce-desktop-modules ++ virtualbox-guest-modules
            ++ [
            ./hardware-configuration.nix # hardware-configuration/vm-icleary-nixos.nix
            ./configuration.nix # hosts/vm-icleary-nixos.nix
            ./home/icleary-xfce.nix
          ];
        };
      };
    };
}