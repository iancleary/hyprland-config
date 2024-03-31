{
  description = "iancleary's example config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: 
  {
    nixosModules.default = import ./modules/nixos;
    nixosModules.nixos = import ./modules/nixos;
    nixosModules.home-manager = import ./modules/home-manager;
  };
}