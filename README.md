# Current State

NixOS and Home Manager configuration for the `lime` desktop. Host-specific
configuration lives in `hosts/lime`; reusable NixOS and Home Manager features
live in `modules/nixos` and `home/modules` respectively.

# What to do on a first NixOS install


```zsh
nix-shell -p git
# pull this repo down, cd into it
# On NixOS, copy the generated hardware file into hosts/lime/.
# cp /etc/nixos/hardware-configuration.nix hosts/lime/
sudo nixos-rebuild switch --flake ~/nix-config#lime
```

# Home Manager only on a non-NixOS system

First, install Nix with the [official multi-user installer](https://nixos.org/download/), then enable flakes for your user:

```sh
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

Clone this repository and activate the standalone Home Manager configuration:

```sh
nix-shell -p git
git clone <repository-url> ~/nix-config
cd ~/nix-config
nix run github:nix-community/home-manager -- switch --flake .#liam
```

After the first activation, Home Manager is available directly. Apply later changes with:

```sh
home-manager switch --flake ~/nix-config#liam
```

The standalone configuration currently targets `x86_64-linux` and expects the user to be named `liam` with the home directory `/home/liam`. Change `homeConfigurations.liam` in `flake.nix` and the values in `home/liam/default.nix` when using a different account.

# Useful checks

```sh
nix flake check
```
