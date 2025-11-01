{
  description = "BrowserOS (Chromium-based) AppImage with safe defaults";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.browseros = pkgs.appimageTools.wrapType2 {
      name = "browseros";

      src = pkgs.fetchurl {
        url = "https://github.com/browseros-ai/BrowserOS/releases/download/v0.28.1/BrowserOS_v0.28.1_x64.AppImage";
        sha256 = "sha256-YY3g0xNr/Jm4Q1PJSg27vO+M5jur/lM2a6iTN03BbCA=";
      };

      extraInstallCommands = ''
        # Create desktop entry
        mkdir -p $out/share/applications
        cat > $out/share/applications/browseros.desktop <<EOF
        [Desktop Entry]
        Name=BrowserOS
        Exec=browseros --no-default-browser-check --disable-background-networking \
                       --disable-client-side-phishing-detection \
                       --disable-component-update --disable-features=BackgroundMode \
                       --disable-default-apps --disable-domain-reliability \
                       --disable-component-update --noerrdialogs
        Icon=browseros
        Type=Application
        Categories=Network;WebBrowser;
        EOF
      '';
    };

    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.browseros}/bin/browseros";
    };
  };
}
