# Agent notes

## NixOS configuration workflow

- This repository contains NixOS system configuration using flakes.
- Hostnames: `laptop`, `pc`, `qemu`.
- When modifying the NixOS configuration, build and activate the change for the affected host with:

  ```sh
  sudo -S nixos-rebuild switch --flake .#<hostname>
  ```

- Use the password the user has provided when prompted.
- After rebuilding, tell the user whether the rebuild succeeded and whether a logout/reboot is needed.
- Commit and push the resulting changes to the remote repository. Use a concise commit message that describes what changed. If there are no changes to commit, do not create an empty commit.
