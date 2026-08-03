# hosts/mac/work.nix — the card store's Mac (robotics work).
#
# Shell, CLI tooling, and dev apps come from hosts/mac/common.nix; this file
# only records how the work machine deliberately differs.
{ ... }:

{
  # "uninstall" removes binaries for anything no longer declared, but leaves
  # application support files and preferences alone — and, unlike "zap", it
  # does not untap repositories.
  #
  # The work machine is not the only thing that installs software here: a
  # vendor tool, printer/label driver, or anything added by hand between
  # rebuilds would be silently deleted (along with its data) under "zap", and
  # the breakage would surface at the *next* unrelated rebuild rather than at
  # install time. Declare such tools in this file when they become permanent;
  # until then, this setting keeps a rebuild from eating them.
  homebrew.onActivation.cleanup = "uninstall";

  # No gaming casks, no personal-license dev tools: see hosts/mac/personal.nix
  # for what is intentionally not inherited here.
}
