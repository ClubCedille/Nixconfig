# flake.nix
{
  description = "Lan ETS - Déploiement NixOS multi-postes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }@inputs:
    {
      nixosConfigurations = {

        # Le nom ici doit correspondre exactement aux choix dans votre manifest.json
        "lanets-default" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./profiles/lanets-default.nix
          ];
        };

      };
    };
}
