with (import <nixpkgs> {});
  {...}:
    derivation {
      name = "docker-selfhost";
      system = builtins.currentSystem;

      src = fetchGit {
        url = "https://github.com/0b11stan/selfhost-docker.git";
        ref = "dev";
        rev = "3a3ff35be3c4dd13737388d971e81e843eac6acc";
        submodules = true;
      };

      inherit coreutils gnused docker;
      builder = "${bash}/bin/bash";
      args = [./docker-selfhost-builder.sh];
    }
