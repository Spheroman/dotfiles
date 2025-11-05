{
  description = "BrowserOS (Chromium-based) AppImage with safe defaults";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.browseros = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.appimageTools.wrapType2 {
      pname = "browseros";
      version = "0.28.1";

      src = pkgs.fetchurl {
        url = "https://github.com/browseros-ai/BrowserOS/releases/download/v0.28.1/BrowserOS_v0.28.1_x64.AppImage";
        sha256 = "sha256-YY3g0xNr/Jm4Q1PJSg27vO+M5jur/lM2a6iTN03BbCA=";
      };

      extra1InstallCommands = ''
        mkdir -p $out/share/applications
        cat > $out/share/applications/browseros.desktop <<EOF
        [Desktop Entry]
        Name=BrowserOS
        Exec=$out/bin/browseros --no-default-browser-check --no-first-run --disable-background-networking \
                       --disable-client-side-phishing-detection --noerrdialogs \
                       --disable-component-update --disable-features=BackgroundMode \
                       --disable-default-apps --disable-domain-reliability
        Icon=$out/share/icons/browseros
        Type=Application
        Categories=Network;WebBrowser;
        Terminal=false
        EOF
      '';
    };

    apps.x86_64-linux.default = {
      type = "app";
      program = "${self.packages.x86_64-linux.browseros}/bin/browseros";
    };
  };
}
