{ stdenv, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "1rrhll1i5ibxdchpdifajvsm697pilf82rbq7arn4f4pw5izrhy6";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  modSha256 = "1z4za3rivc3vqv59p5yb5c9dcpmq669rzmf4z7zilbvmgm0pbgfp";

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
