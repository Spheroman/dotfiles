# users/jackw/secrets.nix
# sops-nix (home-manager module), shared by NixOS and the Macs.
#
# Encrypted values live in secrets/secrets.yaml; recipients are in .sops.yaml.
# Decryption key: ~/.config/sops/age/keys.txt. It is NOT in this repo. Back it
# up somewhere else (password manager), or the secrets are unrecoverable.
# Every machine uses the same age key, so a new one just needs it copied in.
#
# Edit secrets:   sops secrets/secrets.yaml   (from the repo root)
# Add a token:    add it under `env:` in the yaml, then add its name to
#                 envSecrets below. It's exported in every new zsh.
{ config, lib, pkgs, inputs, ... }:

let
  # Names under `env:` in secrets.yaml, exported as shell variables.
  envSecrets = [
    "EXAMPLE_TOKEN"
  ];
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets =
      lib.genAttrs (map (n: "env/${n}") envSecrets) (_: { })
      // lib.genAttrs [ "ssh/id_ed25519" "ssh/id_ed25519_work" ] (name: {
        # id_ed25519 keeps its own passphrase inside the encrypted blob.
        path = "${config.home.homeDirectory}/.${name}";
        mode = "0600";
      });
  };

  # Public halves aren't secret; tracked as plain files.
  home.file.".ssh/id_ed25519.pub".source = ../../secrets/id_ed25519.pub;
  home.file.".ssh/id_ed25519_work.pub".source = ../../secrets/id_ed25519_work.pub;

  programs.zsh.initContent = lib.mkAfter (lib.concatMapStrings (n: ''
    [[ -r ${config.sops.secrets."env/${n}".path} ]] && export ${n}="$(<${config.sops.secrets."env/${n}".path})"
  '') envSecrets);

  # CLIs for editing secrets/secrets.yaml and handling the age key.
  home.packages = with pkgs; [
    age
    sops
  ];
}
