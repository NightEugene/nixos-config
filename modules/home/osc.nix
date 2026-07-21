{ pkgs, ... }:

let
  osc = pkgs.python3Packages.buildPythonPackage rec {
    pname = "osc";
    version = "1.27.2";

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/o/osc/osc-${version}.tar.gz";
      hash = "sha256-hXcy/zM8bci5bhOsRw8R7cT0TV6CktCAjsVTARMILP0=";
    };

    format = "setuptools";

    propagatedBuildInputs = with pkgs.python3Packages; [
      cryptography
      rpm
      ruamel-yaml
      urllib3
    ];

    meta = {
      description = "Command-line client for the Open Build Service";
      homepage = "https://github.com/openSUSE/osc";
      license = pkgs.lib.licenses.gpl2Plus;
      platforms = pkgs.lib.platforms.linux;
    };
  };
in
{
  home.packages = [ osc ];
}
