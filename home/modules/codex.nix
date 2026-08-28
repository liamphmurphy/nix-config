{ ... }:

{
  # Keep the project harness in the Nix configuration so Home Manager installs
  # it consistently on every machine/profile.
  home.file.".codex/skills/project-harness" = {
    source = ../files/codex/project-harness;
    recursive = true;
    # Replace the equivalent manually installed copy on first activation.
    force = true;
  };
}
