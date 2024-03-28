{
  description = "iancleary's example config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # systems.url = "github:nix-systems/default-linux";

    # hyprland.url = "github:hyprwm/Hyprland";

    # hyprland-contrib = {
    #   url = "github:hyprwm/contrib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: 
  {
    nixosModules.default = { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          hello
        ];
      };

    # nixosModules.default = import ./hyprland.nix inputs;
  };
}