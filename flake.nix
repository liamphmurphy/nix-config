{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    walker.url = "github:abenz1267/walker";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      chaotic,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.lime = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/lime
          chaotic.nixosModules.default
          inputs.home-manager.nixosModules.default
        ];
      };

      # Standalone Home Manager configuration for non-NixOS systems.
      homeConfigurations.liam = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/liam ];
      };

      homeConfigurations.work = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/work ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      checks.x86_64-linux.format =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.runCommand "nix-config-format-check"
          {
            nativeBuildInputs = [ pkgs.nixfmt-tree ];
          }
          ''
            cd ${self}
            nixfmt-tree --ci
            touch $out
          '';
    };
}
