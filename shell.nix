let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  inherit (pkgs.lib) optional optionals;
in with pkgs;

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    direnv
    cachix
    curl
    htop
    moreutils
    niv
    nixpkgs-fmt
    pre-commit
    tmate
    tmux
    wget
    zsh
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  NIX_ENFORCE_PURITY = true;

  shellHook = ''
    ${(import ./default.nix).pre-commit-check.shellHook}
  '';
}
