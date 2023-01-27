with (import <nixpkgs> {});
  {...}:
    derivation {
      name = "docker-selfhost";
      system = builtins.currentSystem;

      src = fetchGit {
        url = "https://github.com/0b11stan/selfhost-docker.git";
        ref = "dev";
        rev = "fa3d38e0c0080fabf9d311da0141b44d5184fe36";
        submodules = true;
      };

      inherit coreutils gnused docker;
      builder = "${bash}/bin/bash";
      args = [./docker-selfhost-builder.sh];
    }
