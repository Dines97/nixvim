{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "neoclip";
  originalName = "nvim-neoclip.lua";
  defaultPackage = pkgs.vimPlugins.nvim-neoclip-lua;

  maintainers = [ helpers.maintainers.Dines97 ];

  settingsOptions = {
    enable_persistent_history = helpers.defaultNullOpts.mkBool false ''
      Enable persistent history.
    '';

    continuous_sync = helpers.defaultNullOpts false ''
      Enable continuous sync.
    '';
  };

  extraConfig =
    cfg:
    lib.mkMerge [
      # Dependency
      { plugins.telescope.enable = true; }
      (lib.mkIf cfg.settings.enable_persistent_history { plugins.sqlite-lua.enable = true; })
    ];
}
