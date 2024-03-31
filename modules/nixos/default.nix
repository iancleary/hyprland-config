# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
let
  # Mixing unstable and stable channels
  # https://nixos.wiki/index.php?title=FAQ&oldid=3528#How_can_I_install_a_package_from_unstable_while_remaining_on_the_stable_channel.3F
  pkgs-unstable = (import inputs.nixpkgs-unstable) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  imports = [
    # custom package
    ./power-panel.nix
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Install Flatpak
  services.flatpak.enable = true;

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # swaylock
  # https://discourse.nixos.org/t/swaylock-wont-unlock/27275
  security.pam.services.swaylock = { };
  security.pam.services.swaylock.fprintAuth = false;

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    # xdg-desktop-portal-hyprland # display portal for hyprland, required
    hyprpaper # wallpaper utility
    hyprpicker # color picker
    wl-clipboard # allows copying to clipboard (for hyprpicker)

    kitty # terminal emulator
    waybar # wayland bar

    wofi # app launcher

    # waybar applets
    networkmanagerapplet # nm-applet --indicator &
    blueman # blueman-applet

    udiskie # removable media/disk mounting

    polkit_gnome # polkit agent for GNOME
    gnome.seahorse # keyring manager GUI
    gnome.nautilus # file manager

    playerctl # media player control
    brightnessctl # brightness control

    blueberry # bluetooth manager GUI
    networkmanager # network manager, including nmtui, a network manager TUI

    swaylock # screen locker

    xdg-utils # allow xdg-open to work

    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    # pkgs-unstable.lemurs # TUI Login manager (crashes on NixOS)
  ];
}