# users/jackw/packages/development.nix
# Development tools and runtimes
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python — uv manages interpreters and tools, same as on the Macs.
    # (VS Code itself comes from programs.vscode in ../programs.)
    uv

    # JavaScript/TypeScript
    nodejs
    bun

    # Database
    sqlite

    # AI
    lmstudio
    claude-code
    gemini-cli
  ];
}
