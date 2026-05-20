{ config, lib, pkgs, ... }:

{
  imports =
    [ 
    ./hardware-configuration.nix
      ./submodules/extra.nix
    ];

# Диспетчер загрузки systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Модуль ядра usb_storage
  boot.initrd.availableKernelModules = [ "usb_storage" ];

  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  networking.hostName = "nixos";

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

# security.pki.certificateFiles = [
#  "/etc/ssl/local-certs/mkcert-ca.crt"
# ];
#  security.pki.certificateFiles = [(builtins.readFile /home/aleks/.local/share/mkcert/rootCA.pem)];
# security.pki.certificateFiles = ["/home/aleks/.local/share/mkcert/rootCA.pem"];
security.pki.certificateFiles = [ ./certs/mkcert-ca.crt ];

# Служба управления сетевыми подключениями
  networking.networkmanager.enable = true;

# Настройка часового пояса
  time.timeZone = "Europe/Moscow";

# Глобальная настройка прокси-сервера
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Локаль по умолчанию
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
# Дата и время
    LC_TIME = "ru_RU.UTF-8";       
# Числа (запятая как разделитель)
    LC_NUMERIC = "ru_RU.UTF-8";    
# Формат бумаги А4
    LC_PAPER = "ru_RU.UTF-8";      
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru";
# useXkbConfig = true; 
  };

# Диспетчер отображения
  services.displayManager.ly.enable = true;

# Сервер отображения X11
  services.xserver = {
    enable = true;
    autoRepeatDelay = 300;
    autoRepeatInterval = 35;
# Диспетчер окон
    windowManager.qtile.enable = true; 
# Раскладки клавиатуры
    xkb.layout = "us,ru"; 
# Комбинации клавиш для переключения раскладки клавиатур; замена местами клавиш Escape и Caps Lock
    xkb.options = "grp:alt_shift_toggle, caps:swapescape";
    # BlankTime — время до отключения изображения (экран гаснет, но система работает)
    # StandbyTime — время до перехода в режим энергосбережения с частичным отключением
    # SuspendTime — время до перехода в режим глубококого энергосбережения (почти полного отключения)
    # OffTime —  время до полного выключения экрана
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      '';
  };

# Служба печати
# services.printing.enable = true;

# Отключение звукового сервера PulseAudio
  services.pulseaudio.enable = false;
# Служба RealtimeKit (повышает приоритет аудиопроцессов для уменьшения задержек)
  security.rtkit.enable = true;

# Мультимедийный сервер PipeWire 
  services.pipewire = {
    enable = true;
# Поддержки ALSA (низкоуровневый доступ к аудиоустройствам)
    alsa.enable = true;
# Обеспечение совместимости с 32-битными приложениями
    alsa.support32Bit = true;
# Обеспечение совместимости с PulseAudio
    pulse.enable = true;
# Обеспечение поддержки JACK (профессиональное аудио)
    jack.enable = true;
  };

# Сенсорные устройства
# services.libinput.enable = true;

# Учётная запись
  users.users.aleks = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
      tree
      ];
  };

  programs.firefox.enable = true;

# Файловый менеджер
  programs.thunar.enable = true;
# Система хранения настроек рабочего стола 
# programs.xfconf.enable = true;

  services.udisks2.enable = true;

# Глобальный список пакетов (https://search.nixos.org)
  environment.systemPackages = with pkgs; [
    vim 
      wget
  ];

# Псевонимы команд
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
  };

# Шрифты
  fonts.packages = with pkgs; [
    fira-code
  ];

  nix.settings = {
# Экспериментальные функции системы управления пакетами
    experimental-features = [
      "nix-command"
        "flakes"
    ];
    warn-dirty = false;
  };

# Сетевая диагностика
  programs.mtr.enable = true;

# GNU Privacy Guard
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# Сервер OpenSSH
# services.openssh.enable = true;

# Списки портов, открытых для входящих подключений
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Отключение межсетевого экрана 
  networking.firewall.enable = false;

# Подсистема Linux, обеспечивающая фильтрацию и классификацию сетевых пакетов
  networking.nftables.enable = true; 


# Номер первой установленной версии NixOS только для чтения
  system.stateVersion = "25.11";
}

