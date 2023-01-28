with (import <nixpkgs> {});
  {...}:
    derivation {
      name = "docker-selfhost";
      system = builtins.currentSystem;

      src = fetchGit {
        url = "https://github.com/0b11stan/selfhost-docker.git";
        ref = "dev";
        rev = "b8065b9d0238afc4dccc6474ad93317e2aee3160";
        submodules = true;
      };

      inherit coreutils gnused docker;
      builder = "${bash}/bin/bash";
      args = [./docker-selfhost-builder.sh];
    }
