{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    tree
    brave
    mpv
    spotify
    zoom-us
    brightnessctl
    ranger

    #######################################
    # neovim
    #######################################
    neovim

    # lsp
    lua-language-server
    nixd

    # formatters
    stylua
    nixfmt-rfc-style

    # dependencies
    fzf
    fd
    ripgrep
    gcc
    #######################################
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "lapis";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users.matt = import ./home.nix;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:swapcaps";
  };

  fonts = {
    packages = with pkgs; [
      fantasque-sans-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Fantasque Sans Mono" ];
      serif = [ "Fantasque Sans Mono" ];
      sansSerif = [ "Fantasque Sans Mono" ];
    };
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
