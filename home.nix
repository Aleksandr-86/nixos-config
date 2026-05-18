{ config, pkgs, ... }:

let
dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  imports = [
    ./submodules/git.nix
  ];

  home.username = "aleks";
  home.homeDirectory = "/home/aleks";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

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

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
    steoates.autoimport
    wmaurer.change-case
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-russian
    MS-CEINTL.vscode-language-pack-ru
    mikestead.dotenv
    dbaeumer.vscode-eslint
    eamodio.gitlens
    oderwat.indent-rainbow
    DavidLGoldberg.jumpy2
    PKief.material-icon-theme
    azemoh.one-monokai
    esbenp.prettier-vscode
    sainoba.px-to-rem
    stylelint.vscode-stylelint
    bradlc.vscode-tailwindcss
    omercohen.toggle-test-only
    vscodevim.vim
    vitest.explorer
    Vue.volar
    ];
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
