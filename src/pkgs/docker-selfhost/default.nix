with (import <nixpkgs> {});
  {...}:
    derivation {
      name = "docker-selfhost";
      system = builtins.currentSystem;

      src = fetchGit {
        url = "https://github.com/0b11stan/selfhost-docker.git";
        ref = "master";
        rev = "63a95635c2bf34c6ce51df101d10c905b81e867d";
        submodules = true;
      };

      inherit coreutils gnused docker;
      builder = "${bash}/bin/bash";
      args = [./builder.sh];
    }
