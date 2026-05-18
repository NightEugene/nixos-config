hostname := `hostname`

# List all available commands
@default:
    just --list --unsorted

# Apply the new configuration immediately
@switch:
    nh os switch path:./#{{hostname}} -- --accept-flake-config

# Make the new configuration the default boot option
@boot:
    nh os boot path:./#{{hostname}} -- --accept-flake-config

# Clean old NixOS generations and garbage collect
@gc:
    nh clean all
