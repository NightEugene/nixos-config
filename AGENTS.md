# Agent notes

## NixOS configuration workflow

- This repository contains NixOS system configuration using flakes.
- Hostnames: `laptop`, `pc`, `qemu`.
- The active session runs on `laptop`.

### Applying changes

- When modifying the NixOS or home-manager configuration, apply the change for `laptop` immediately with:

  ```sh
  sudo -S nixos-rebuild switch --flake .#laptop
  ```

  The password is provided by the user at runtime; never hard-code or commit it.

- Do not wait for the user to apply changes manually.
- After rebuilding, report whether it succeeded and whether a logout/reboot is needed.

### Validation for other hosts

- After any change, also verify that `pc` and `qemu` still build:

  ```sh
  nix build .#nixosConfigurations.pc.config.system.build.toplevel .#nixosConfigurations.qemu.config.system.build.toplevel --no-link
  ```

### Commit and push

- Commit and push the resulting changes to the remote repository.
- Use a concise commit message that describes what changed.
- If there are no changes to commit, do not create an empty commit.

### Host-specific conventions

- `laptop`:
  - Power management is configured via `services.auto-cpufreq` in `hosts/laptop/hardware-configuration.nix`.
  - The Noctalia bar includes `battery` and `brightness` widgets.
- `pc` / `qemu`:
  - No battery widget in Noctalia.
  - Use the same unified Noctalia config as `laptop` (see `modules/home/noctaliaCommon.toml`), only overriding host-specific placeholders.

### Adding flake packages

- Prefer adding packages to the shared home config in `modules/home/default.nix`.
- For packages that come from a GitHub flake, add the input to `flake.nix` first, then reference it as `inputs.<name>.packages.${pkgs.stdenv.hostPlatform.system}.default` in `modules/home/default.nix`.
- Update `flake.lock` with `nix flake lock --update-input <name>` when adding or updating an input.
