{ config, pkgs, ... }:

let
dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  imports = [
    ./submodules/git.nix
  ];

  home.packages = with pkgs; [
# Редакторы и среды разработки
    vscode
      neovim
# Контейнеризация
      docker-compose
# Система контроля версий
      git
# Пакетный менеджер 
      yarn
# Создание SSL-сертификатов 
      mkcert
# Снимки экрана
      flameshot
# Музыкальный проигрыватель
      mpd

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

  home.username = "aleks";
  home.homeDirectory = "/home/aleks";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/mnt/shared/Музыка";
      network = {
        startWhenNeeded = true;
      };
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      PS1="\w\[\e[38;2;166;227;161m\]# \[\e[0m\]"
      '';
  };

  programs.rofi.enable = true;
  programs.vscode.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = { x = 8; y = 8; };
      font = {
        size = 14.0;
      };
      colors = {
        primary = {
          background = "0x1e1e1e";
          foreground = "0xd4d4d4";
        };
      };
    };
  };

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


}
