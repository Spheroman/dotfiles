# users/jackw/packages/development.nix
# Development tools and runtimes
{ pkgs, ... }:

let
  bjarne = pkgs.callPackage ./bjarne.nix { };
in
{
  home.packages = with pkgs; [
    # Editors
    vscode
    antigravity

    # IDEs
    jetbrains.pycharm-professional

    # Python
    python313
    python313Packages.importmagic
    python313Packages.flake8
    basedpyright

    # JavaScript/TypeScript
    nodejs
    bun

    # Database
    sqlite

    # AI
    lmstudio
    claude-code
    gemini-cli
    bjarne
  ];
}
