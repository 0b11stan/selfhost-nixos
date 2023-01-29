with (import <nixpkgs> {});
  {...}:
    derivation {
      name = "docker-selfhost";
      system = builtins.currentSystem;

      src = fetchGit {
        url = "https://github.com/0b11stan/selfhost-docker.git";
        ref = "master";
        rev = "b164f56749ae193729430f940024e27c6ef0b1e7";
        submodules = true;
      };

      inherit coreutils gnused docker;
      builder = "${bash}/bin/bash";
      args = [./builder.sh];
    }
