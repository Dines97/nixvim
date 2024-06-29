{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "legendary";
  originalName = "legendary.nvim";
  defaultPackage = pkgs.vimPlugins.legendary-nvim;

  maintainers = [ helpers.maintainers.Dines97 ];

  settingsOptions = {
    keymaps = lib.mkOption { type = lib.types.listOf helpers.keymaps.mapOptionSubmodule; };
  };

  extraConfig = cfg: { };
}
