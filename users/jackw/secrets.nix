# users/jackw/secrets.nix
# sops-nix secrets management
# 
# SETUP INSTRUCTIONS:
# 1. Generate an age key: `age-keygen -o ~/.config/sops/age/keys.txt`
# 2. Get your public key: `age-keygen -y ~/.config/sops/age/keys.txt`
# 3. Create .sops.yaml in /etc/nixos with your public key
# 4. Create secrets file: `sops /etc/nixos/secrets/secrets.yaml`
#
# Example .sops.yaml:
# keys:
#   - &jackw age1xxxxxxxxxxxxxxxxxxxxxxxxxx
# creation_rules:
#   - path_regex: secrets/.*\.yaml$
#     key_groups:
#       - age:
#         - *jackw
#
{ config, pkgs, lib, ... }:

{
  # sops-nix configuration
  # Uncomment after running setup steps above

  # sops = {
  #   defaultSopsFile = ../../secrets/secrets.yaml;
  #   age.keyFile = "/home/jackw/.config/sops/age/keys.txt";
  #   
  #   secrets = {
  #     # Example secrets - add as needed
  #     # "github-token" = {};
  #     # "ssh-private-key" = {
  #     #   path = "/home/jackw/.ssh/id_ed25519";
  #     #   owner = "jackw";
  #     #   mode = "0600";
  #     # };
  #   };
  # };

  # Required packages for secrets management
  home.packages = with pkgs; [
    age        # Encryption tool
    sops       # Secrets operations
  ];
}
