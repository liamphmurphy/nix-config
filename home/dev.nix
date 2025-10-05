# Cross-platform dev env (Home Manager module)
{ config, pkgs, lib, ... }:

{
  # Go toolchain via HM
  programs.go.enable = true;

  home.packages = with pkgs; [
    # K8s
    kubectl
    kind
    kubernetes-helm
    kubectx

    # VCS & editor deps
    git
    ripgrep
    fd
    tree-sitter
    lua-language-server
    nodejs
    gcc

    # (optional) Go LSP for LazyVim extras.lang.go
    go
    gopls
  ];

  # Neovim core
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # No xdg.* here — keep this block strictly for neovim options.
  };

  # --- LazyVim bootstrap & config files ---
  # ~/.config/nvim/init.lua
  xdg.configFile."nvim/init.lua".text = ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
      })
    end
    vim.opt.rtp:prepend(lazypath)

    -- all LazyVim config lives under lua/config and lua/plugins
    require("config.lazy")
  '';

  # ~/.config/nvim/lua/config/lazy.lua
  xdg.configFile."nvim/lua/config/lazy.lua".text = ''
    require("lazy").setup({
      spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },

        -- Extras you want:
        { import = "lazyvim.plugins.extras.lang.go" },
        -- Enable if you use it; requires auth inside Neovim
        { import = "lazyvim.plugins.extras.coding.copilot" },

        -- Your own plugins folder:
        { import = "plugins" },
      },
      defaults = { lazy = false, version = false },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = { enabled = false },
      performance = {
        rtp = {
          disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
      },
    })
  '';

  # Example plugin spec: ~/.config/nvim/lua/plugins/init.lua
  xdg.configFile."nvim/lua/plugins/init.lua".text = ''
    return {
      { "nvim-lualine/lualine.nvim", opts = {} },
      { "folke/which-key.nvim", opts = {} },
    }
  '';

  # Environment
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

