let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  nix-pre-commit-hooks = import sources.pre-commit-hooks-nix;
  inherit (pkgs.lib) optional optionals;

in with pkgs; {
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    # If your hooks are intrusive, avoid running on each commit with a default_states like this:
    # default_stages = ["manual" "push"];
    hooks = {
      clippy.enable = true;
      hadolint.enable = true;
      nix-linter.enable = false;
      nixfmt.enable = true;
      rustfmt.enable = true;
      shellcheck.enable = true;
    };
  };
}
