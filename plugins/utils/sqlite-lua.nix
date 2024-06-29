{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "sqlite-lua";
  originalName = "sqlite.lua";
  defaultPackage = pkgs.vimPlugins.sqlite-lua;

  maintainers = [ helpers.maintainers.Dines97 ];

  callSetup = false;

  extraConfig = cfg: {
    globals = {
      sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    };
  };
}
