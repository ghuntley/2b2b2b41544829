let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  inherit (pkgs.lib) optional optionals;
in
  with pkgs;

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    direnv
    cachix
    curl
    htop
    lorri
    moreutils
    niv
    pre-commit
    tmate
    tmux
    wget
    zsh
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  NIX_ENFORCE_PURITY = true;

  shellHook = ''
    export LANG='en_US.UTF-8';
    export LANGUAGE='en_US:en';
    export LC_ALL='en_US.UTF-8';

    cachix use cachix

    pre-commit install
    pre-commit autoupdate
  '';
}
