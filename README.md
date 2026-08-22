# Current State

Builds a functional system I like with NixOS, using flake / home-manager. The stuff I can use on non-NixOS systems are seperated into `home/*.nix` files.

# What to do on a first NixOS install


```zsh
nix-shell -p git
# pull this repo down, cd into it
# if on nixos, ignore if just doing home-manger: cp /etc/nixos/hardware-configuration.nix .
sudo nixos-rebuild switch --flake ~/nix-config#homepc ## or whatever host im targeting instead of homepc
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

The standalone configuration currently targets `x86_64-linux` and expects the user to be named `liam` with the home directory `/home/liam`. Change `homeConfigurations.liam` in `flake.nix` and the `home.username` and `home.homeDirectory` values in `home/homepc.nix` when using a different account.

# Next Steps

- Setup LazyVim
- Fix ctrl+c not copying in browsers
- rice up my waybar config a bit
