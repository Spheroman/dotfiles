{ pkgs, stdenv, fetchFromGitHub, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "bjarne";
  version = "2026-01-17";

  src = fetchFromGitHub {
    owner = "Dekadinious";
    repo = "bjarne";
    rev = "355118f67ae182304c9c77c12ed21ad1e8b8ce4d";
    sha256 = "16s9ihz8djsp8y4sbarbsb9vh84bf67rhgvb1sjisisqn4vxmp85";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 bjarne $out/bin/bjarne
    wrapProgram $out/bin/bjarne \
      --prefix PATH : ${pkgs.lib.makeBinPath [ 
        pkgs.claude-code 
        pkgs.git 
        pkgs.gh 
        pkgs.docker 
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.gnused
      ]}
  '';

  meta = with pkgs.lib; {
    description = "Autonomous AI development loop using Claude";
    homepage = "https://github.com/Dekadinious/bjarne";
    platforms = platforms.all;
  };
}
