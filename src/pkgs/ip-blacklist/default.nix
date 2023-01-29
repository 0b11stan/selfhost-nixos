with (import <nixpkgs> {});
  {...}:
    derivation {
      name = "ip-blacklist.sh";
      system = builtins.currentSystem;
      src = ./list.txt;
      inherit coreutils gnused;
      builder = "${bash}/bin/bash";
      args = [./builder.sh];
    }
