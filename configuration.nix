# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ 
    ./hardware-configuration.nix
      ./submodules/extra.nix
    ];

# Включение диспетчера загрузки systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

# Включение службы управления сетевыми подключениями
  networking.networkmanager.enable = true;

# Настройка часового пояса
  time.timeZone = "Europe/Moscow";

# Глобальная настройка прокси-сервера
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Региональная настройка
  i18n.defaultLocale = "ru_RU.UTF-8";

# Дополнительные локали (для программ, требующих английскую локаль)
  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
  ];

# Тонкая настройка отдельных категорий локалей
  i18n.extraLocaleSettings = {
# Сортировка
    LC_COLLATE = "en_US.UTF-8";    
# Сообщения
    LC_MESSAGES = "ru_RU.UTF-8";  
# Дата/время
    LC_TIME = "ru_RU.UTF-8";       
# Числа - русский формат (запятая как разделитель)
    LC_NUMERIC = "ru_RU.UTF-8";    
# Формат бумаги - русский формат (А4)
    LC_PAPER = "ru_RU.UTF-8";      
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru";
# useXkbConfig = true; 
  };

# Включение диспетчера отображения
  services.displayManager.ly.enable = true;

# Включение и настройка сервера отображения X11
  services.xserver = {
    enable = true;
    autoRepeatDelay = 300;
    autoRepeatInterval = 35;
# Включение диспетчера окон
    windowManager.qtile.enable = true; 
# Установка раскладок клавиатур
    xkb.layout = "us,ru"; 
# Настройка комбинации клавиш для переключения раскладок клавиатур и замена местами клавиш Escape и Caps Lock
    xkb.options = "grp:alt_shift_toggle, caps:swapescape";
  };

# Включение службы печати
# services.printing.enable = true;

# Отключение звукового сервера PulseAudio
  services.pulseaudio.enable = false;
# Включение службы RealtimeKit (повышает приоритет аудиопроцессов для уменьшения задержек)
  security.rtkit.enable = true;

# Включение и настройка мультимедийного сервера PipeWire 
  services.pipewire = {
    enable = true;
# Включение поддержки ALSA (низкоуровневый доступ к аудиоустройствам)
    alsa.enable = true;
# Обеспечение совместимости с 32-битными приложениями
    alsa.support32Bit = true;
# Обеспечение совместимости с PulseAudio
    pulse.enable = true;
# Обеспечение поддержки JACK (профессиональное аудио)
    jack.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
# services.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aleks = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
      tree
      ];
  };

  programs.firefox.enable = true;

  programs.thunar.enable = true; # включение файлового менеджера
# programs.xfconf.enable = true; # сохранение настроек менеджера

    services.udisks2.enable = true;

#  автоматическое монтирование съёмных носителей
#  services.udiskie = {
#    enable = true;
#    settings = {
#      program_options = {
#        file_manager = "${pkgs.thunar}/bin/thunar";
#      };
#    };
#  };

# List packages installed in system profile.
# You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim 
      wget
      alacritty
  ];

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
  };

  fonts.packages = with pkgs; [
    fira-code
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

  networking.nftables.enable = true; 

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}

