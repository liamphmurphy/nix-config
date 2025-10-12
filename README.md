# Current State

Builds a functional system I like with NixOS, using flake / home-manager. The stuff I can use on non-NixOS systems are seperated into `home/*.nix` files.

# what to do on a first install


```zsh
nix-shell -p git
# pull this repo down, cd into it
# if on nixos, ignore if just doing home-manger: cp /etc/nixos/hardware-configuration.nix .
sudo nixos-rebuild switch --flake ~/nix-config#homepc ## or whatever host im targeting instead of homepc
```

# Next Steps

- Setup LazyVim
- Fix ctrl+c not copying in browsers
- rice up my waybar config a bit
