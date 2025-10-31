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
    obsidian
    libnotify
    wl-clipboard
    swayidle
    pinentry-gtk2
    pass
    bemoji
    anki
    slack

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
    tree-sitter
    #######################################
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.kernelParams = [
    "iwlwifi.11n_disable=1"
    "iwlwifi.swcrypto=1"
    "iwlwifi.power_save=0"
  ];

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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCNDIBIA6zcf8J13vBl9jqMyd/bHqgLCh3W/uNe9v9l matt.muldowney@gmail.com"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
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
      nerd-fonts.caskaydia-cove
      noto-fonts
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Fantasque Sans Mono" ];
      serif = [ "Fantasque Sans Mono" ];
      sansSerif = [ "Fantasque Sans Mono" ];
    };
  };

  environment.localBinInPath = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  programs.browserpass.enable = true;

  services.tlp.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      Policy = {
        AutoEnable = false;
      };
    };
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
