# users/jackw/packages/development.nix
# Development tools and runtimes
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    neovim
    vscode
    antigravity

    # IDEs
    jetbrains.pycharm-professional

    # Python
    python313
    python313Packages.importmagic
    python313Packages.flake8
    basedpyright

    # Database
    sqlite

    # AI
    lmstudio
  ];
}
