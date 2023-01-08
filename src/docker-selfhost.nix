with (import <nixpkgs> {});
  {fetchFromGitHub, ...}:
    derivation {
      name = "docker-selfhost";
      system = builtins.currentSystem;

      #      src = fetchFromGitHub {
      #        owner = "0b11stan";
      #        repo = "selfhost-docker";
      #        rev = "dev";
      #        sha256 = "sha256-nvsAO1yb+DHZ3O96JXmtLVkXMNHehf8I9F35i/A4mGM=";
      #        fetchSubmodules = true;
      #      };

      src = fetchGit {
        url = "https://github.com/0b11stan/selfhost-docker.git";
        ref = "dev";
        submodules = true;
      };

      inherit coreutils gnused docker;
      builder = "${bash}/bin/bash";
      args = [./docker-selfhost-builder.sh];
    }
