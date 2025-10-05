# This is for any development env config that is likely to be cross-platform
{ config, pkgs, lib, ... }:

{
   # Details o nwaht this does: https://github.com/nix-community/home-manager/blob/release-25.05/modules/programs/go.nix
   programs.go.enable = true;

   home.packages = with pkgs; [
	# K8s things
	kubectl
	kind
	kubernetes-helm
	kubectx

	git
   ];


  # Setup neovim
  programs.neovim = {
	enable = true;

	defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # tools LazyVim expects
    extraPackages = with pkgs; [
      ripgrep fd git tree-sitter lua-language-server nodejs
      gcc # for native builds
    ];

  # ~/.config/nvim/init.lua
  xdg.configFile."nvim/init.lua".text = ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git","clone","--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath
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
        { import = "lazyvim.plugins.extras.coding.copilot" },
        -- Your own plugins folder:
        { import = "plugins" },
      },
      defaults = { lazy = false, version = false },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = { enabled = false },
      performance = {
        rtp = { disabled_plugins = { "gzip","tarPlugin","tohtml","tutor","zipPlugin" } },
      },
    })
  '';

  # Example: your own plugin spec at ~/.config/nvim/lua/plugins/init.lua
  xdg.configFile."nvim/lua/plugins/init.lua".text = ''
    return {
      { "nvim-lualine/lualine.nvim", opts = {} },
      { "folke/which-key.nvim", opts = {} },
    }
  '';
  };

  home.sessionVariables = {
    EDITOR = "neovim";
  };

}
