{
  config,
  lib,
  pkgs,
  ...
}: let
  djangokey = builtins.getEnv "DJANGO_SECRET_KEY";
in {
  imports = [./hardware-configuration.remote.nix];

  networking = {
    hostName = "selfhost";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 2222 8080 11000];
      extraCommands = ''
        iptables -F DOCKER-USER
        ${pkgs.ip-blacklist}
        iptables -A DOCKER-USER -j RETURN
      '';
    };
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.users.tristan = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [neovim git];
    openssh.authorizedKeys.keyFiles = [
      ./ssh-keys/silver-hp.pub
      ./ssh-keys/desktop.pub
    ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.buildkit = false;
  };

  nixpkgs.overlays = [
    (self: super: {
      docker-selfhost = super.callPackage ./pkgs/docker-selfhost {};
      ip-blacklist = super.callPackage ./pkgs/ip-blacklist {};
    })
  ];

  environment.systemPackages = [pkgs.docker-selfhost];

  systemd.services.selfhost = {
    enable = true;
    restartIfChanged = true;
    wantedBy = ["multi-user.target"];
    after = ["docker.service"];
    bindsTo = ["docker.service"];
    documentation = ["https://github.com/0b11stan/selfhost-docker"];
    script = "${pkgs.docker-selfhost}/start.sh";
    preStop = "${pkgs.docker-selfhost}/stop.sh";
    reload = "${pkgs.docker-selfhost}/reload.sh";
    #reloadTriggers = [pkgs.docker-selfhost];
    reloadIfChanged = true;
    environment.DJANGO_SECRET_KEY = djangokey;
  };

  system.stateVersion = "22.11"; # DO NOT MODIFY
}
