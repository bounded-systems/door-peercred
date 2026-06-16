{
  # door-peercred — the SO_PEERCRED helper for launcherd (Rust).
  #
  # Extracted from claude-box (epic prx-ii01, card 3). A tiny, dependency-free
  # binary that reads SO_PEERCRED off a unix socket and injects the caller's
  # UID/GID/PID — the launcher uses it to identify in-box callers. It is a
  # launcherd helper, NOT a door. Linux-only (SO_PEERCRED). claude-box pins this
  # repo and builds the binary via nix; this flake builds it standalone too.
  description = "door-peercred — SO_PEERCRED helper for launcherd (Rust)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/9f11f828c213641c2369a9f1fa31fe31557e3156";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forEach = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      packages = forEach (system:
        let pkgs = pkgsFor system;
        in {
          peercred = pkgs.rustPlatform.buildRustPackage {
            pname = "peercred";
            version = "0.1.0";
            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;
          };
          default = self.packages.${system}.peercred;
        });
    };
}
