{
  description = "Rust-Nix";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    crate2nix.url = "github:nix-community/crate2nix";
  };

  nixConfig = {
    extra-trusted-public-keys = "eigenvalue.cachix.org-1:ykerQDDa55PGxU25CETy9wF6uVDpadGGXYrFNJA3TUs=";
    extra-substituters = "https://eigenvalue.cachix.org";
    allow-import-from-derivation = true;
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , flake-parts
    , rust-overlay
    , crate2nix
    , ...
    }: flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { system, pkgs, lib, inputs', ... }:
        let
          # If you dislike IFD, you can also generate it with `crate2nix generate` 
          # on each dependency change and import it here with `import ./Cargo.nix`.
          cargoNix = inputs.crate2nix.tools.${system}.appliedCargoNix {
            name = "rustnix";
            src = ./.;
          };
        in
        rec {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (import inputs.rust-overlay)
              (self: super: assert !(super ? rust-toolchain); rec {
                rust-toolchain = super.rust-bin.nightly.latest.default.override {
                  extensions = [ "rust-src" ];
                };

                # buildRustCrate/crate2nix depend on this.
                rustc = rust-toolchain;
                cargo = rust-toolchain;
              })
            ];
          };

          checks = {
            rustnix = cargoNix.rootCrate.build.override {
              runTests = true;
            };
          };

          packages = {
            rustnix = cargoNix.rootCrate.build;
            default = packages.rustnix;
          };

          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                rust-toolchain
              ];
            };
          };
        };
    };
}
