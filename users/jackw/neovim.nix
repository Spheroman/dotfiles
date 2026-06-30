# users/jackw/neovim.nix
# Neovim configuration with LazyVim support
{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # Set as $EDITOR
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    # Entry point: bootstrap lazy.nvim (config lives in lua/config/*.lua below).
    extraLuaConfig = ''
      require("config.lazy")
    '';

    # Install packages needed by LazyVim and common plugins
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil  # Nix LSP
      basedpyright  # Python LSP (you already use this)
      typescript-language-server
      bash-language-server

      # Formatters
      stylua
      nixfmt-rfc-style
      black
      prettier

      # Tools required by LazyVim
      ripgrep  # Telescope grep
      fd       # Telescope find
      git
      lazygit  # Optional: git UI
    ]
    # Treesitter needs a C compiler; clipboard tooling differs per platform.
    ++ lib.optionals pkgs.stdenv.isLinux [ gcc wl-clipboard ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ clang ];
  };

  # LazyVim configuration files
  home.file.".config/nvim/lua/config/lazy.lua".text = ''
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
      spec = {
        -- add LazyVim and import its plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- import/override with your plugins
        { import = "plugins" },
      },
      defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
        lazy = false,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
      },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = {
        enabled = true, -- check for plugin updates periodically
        notify = false, -- notify on update
      }, -- automatically check for plugin updates
      performance = {
        rtp = {
          -- disable some rtp plugins
          disabled_plugins = {
            "gzip",
            -- "matchit",
            -- "matchparen",
            -- "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })
  '';

  home.file.".config/nvim/lua/config/options.lua".text = ''
    -- Options are automatically loaded before lazy.nvim startup
    -- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
    -- Add any additional options here
  '';

  home.file.".config/nvim/lua/config/keymaps.lua".text = ''
    -- Keymaps are automatically loaded on the VeryLazy event
    -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
    -- Add any additional keymaps here
  '';

  home.file.".config/nvim/lua/config/autocmds.lua".text = ''
    -- Autocmds are automatically loaded on the VeryLazy event
    -- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
    --
    -- Add any additional autocmds here
    -- with `vim.api.nvim_create_autocmd`
    --
    -- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
    -- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
  '';

  # Plugins are managed by LazyVim directly
  # Use :LazyExtras in nvim to enable pre-configured extras
  # Or create lua files in ~/.config/nvim/lua/plugins/ to add custom plugins
  # Later, you can make lazyvim.json declarative by adding:
  # home.file.".config/nvim/lazyvim.json".text = ''{ "extras": [...] }'';
}
