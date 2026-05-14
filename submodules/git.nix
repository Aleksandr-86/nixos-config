{ pkgs, ... }:

{
# Здесь вы можете перечислить пакеты или настройки
# home.packages = with pkgs; [
#   htop
#   git
#   vim
# ];

  programs.git = {
    enable = true;
    userName = "Aleksandr-86";
    userEmail = "Aleksandr-Karpenko-86@yandex.ru";
    extraConfig = {
      init.defaultBranch = "main";
    }; 
  };
}
