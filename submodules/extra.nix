{
  environment.shellAliases = {
    zapret = "cd ~/repos/zapret-linux-flake && sudo nix run";
    yandex-install = "cd ~/nixos-dotfiles && nix profile add github:miuirussia/yandex-browser.nix#yandex-browser-stable && nix flake update yandex-browser";
    cfg = "cd ~/nixos-dotfiles && nvim .";
    dev = "cd ~/projects/tenderhelp_python/th-front";
  };
}
