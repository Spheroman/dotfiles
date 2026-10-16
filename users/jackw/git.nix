# users/jackw/git.nix
# git + gh, shared by NixOS and the Macs.
#
# GitHub goes over HTTPS on every machine, authenticated by gh — no SSH key
# has to be on the box first, just `gh auth login`. Remotes that already use
# git@github.com: URLs keep working wherever an SSH key exists.
#
# Each host supplies its own identity via `gitEmail` (extraSpecialArgs in
# flake.nix), so work commits are attributed to the work address rather than
# the personal one. Passing `gitEmail = null` instead leaves user.email unset,
# which makes git refuse to commit until it's set per-repo — useful for a
# machine where no single default identity is right.
{ lib, gitEmail, ... }:

{
  # gh as a git credential helper, wired up by home-manager rather than by
  # `gh auth setup-git`. The imperative command writes a hardcoded store path
  # into ~/.gitconfig, which breaks once that gh build is garbage-collected;
  # this way the path is refreshed on every rebuild and stays a GC root.
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" "https://gist.github.com" ];
    };
  };

  programs.git = {
    enable = true;

    ignores = [ "**/.claude/settings.local.json" ];

    settings.core.autocrlf = "input";

    settings.user = {
      # Merge at the `user` level: `//` is shallow, so merging whole `settings`
      # attrsets here would drop `name` on any host that supplies an email.
      name = "Jack Wen";
    } // lib.optionalAttrs (gitEmail != null) {
      email = gitEmail;
    };
  };
}
