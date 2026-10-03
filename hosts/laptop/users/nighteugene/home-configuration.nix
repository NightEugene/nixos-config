{ flake, pkgs, ... }:

{
  # Linux tooling for Flutter development and signed iOS app deployment.
  # Xcode and the iOS build SDK still require a macOS host.
  home.packages = with pkgs; [
    flutter
    libimobiledevice
    ideviceinstaller
    ifuse
  ];

  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaLaptop
  ];
}
