{ config, pkgs, ... }:

let
dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  imports = [
    ../cfg/git.nix
  ];

  home.username = "aleks";
  home.homeDirectory = "/home/aleks";
  home.stateVersion = "25.11";
  programs.bash.enable = true;
  programs.rofi.enable = true;

# home.file.".config/qtile".source = ./config/qtile;
  xdg.configFile."qtile" = {
# source = config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/qtile/";
    source = create_symlink "${dotfiles}/qtile/";
    recursive = true;
  };
# home.file.".config/nvim".source = ./config/nvim;
  xdg.configFile."nvim" = {
# source = config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/nvim/";
    source = create_symlink "${dotfiles}/nvim/";
    recursive = true;
  };

  home.packages = with pkgs; [
    git
      neovim
      ripgrep
      nil
      nixpkgs-fmt
      nodejs
      gcc
      mpv
      p7zip
      discord
      pavucontrol
  ];
}
