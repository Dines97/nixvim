{
  lib,
  helpers,
  pkgs,
  config,
  options,
  ...
}:
with lib;
{
  options.plugins.which-key = {
    enable = mkEnableOption "which-key.nvim, a plugin that popup with possible key bindings of the command you started typing";

    package = helpers.mkPluginPackageOption "which-key-nvim" pkgs.vimPlugins.which-key-nvim;

    registrations = mkOption {
      type = with types; attrsOf anything;
      description = ''
        This option is deprecated, use `settings.spec` instead.

        Note: the keymap format has changed in v3 of which-key.
      '';
      visible = false;
    };

    settings.spec = helpers.defaultNullOpts.mkListOf' {
      type = with types; attrsOf anything;
      pluginDefault = [ ];
      description = ''
        WhichKey automatically gets the descriptions of your keymaps from the desc attribute of the keymap.
        So for most use-cases, you don't need to do anything else.

        However, the mapping spec is still useful to configure group descriptions and mappings that don't really exist as a regular keymap.

        Please refer to the plugin's [documentation](https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings).
      '';
      example = [
        {
          __unkeyed-1 = "<leader>w";
          desc = "Window actions";
        }
        {
          __unkeyed-1 = "<leader>b";
          desc = "Buffer actions";
        }
        {
          __unkeyed-1 = "<leader>p";
          desc = "Find git files with telescope";
        }
        {
          __unkeyed-1 = "<leader>p";
          __unkeyed-2.__raw = "function() print('Optional action') end";
          desc = "Print \"optional action\"";
        }
      ];
    };

    plugins = {
      marks = helpers.defaultNullOpts.mkBool true "shows a list of your marks on ' and `";

      registers = helpers.defaultNullOpts.mkBool true ''shows your registers on " in NORMAL or <C-r> in INSERT mode'';

      spelling = {
        enabled = helpers.defaultNullOpts.mkBool true "enabling this will show WhichKey when pressing z= to select spelling suggestions";
        suggestions = helpers.defaultNullOpts.mkInt 20 "how many suggestions should be shown in the list?";
      };

      presets = {
        operators = helpers.defaultNullOpts.mkBool true "adds help for operators like d, y, ...";
        motions = helpers.defaultNullOpts.mkBool true "adds help for motions";
        textObjects = helpers.defaultNullOpts.mkBool true "help for text objects triggered after entering an operator";
        windows = helpers.defaultNullOpts.mkBool true "default bindings on <c-w>";
        nav = helpers.defaultNullOpts.mkBool true "misc bindings to work with windows";
        z = helpers.defaultNullOpts.mkBool true "bindings for folds, spelling and others prefixed with z";
        g = helpers.defaultNullOpts.mkBool true "bindings for prefixed with g";
      };
    };

    operators = helpers.defaultNullOpts.mkAttrsOf types.str { gc = "Comments"; } ''
      add operators that will trigger motion and text object completion
      to enable all native operators, set the preset / operators plugin above
    '';

    keyLabels = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
      override the label used to display some keys. It doesn't effect WK in any other way.
    '';

    motions = {
      count = helpers.defaultNullOpts.mkBool true "";
    };

    icons = {
      breadcrumb = helpers.defaultNullOpts.mkStr "»" "symbol used in the command line area that shows your active key combo";
      separator = helpers.defaultNullOpts.mkStr "➜" "symbol used between a key and it's label";
      group = helpers.defaultNullOpts.mkStr "+" "symbol prepended to a group";
    };

    popupMappings = {
      scrollDown = helpers.defaultNullOpts.mkStr "<c-d>" "binding to scroll down inside the popup";
      scrollUp = helpers.defaultNullOpts.mkStr "<c-u>" "binding to scroll up inside the popup";
    };

    window =
      let
        spacingOptions = types.submodule {
          options =
            genAttrs
              [
                "top"
                "right"
                "bottom"
                "left"
              ]
              (
                n:
                mkOption {
                  type = types.ints.unsigned;
                  description = "Spacing at the ${n}.";
                }
              );
        };
      in
      {
        border = helpers.defaultNullOpts.mkBorder "none" "which-key" "";
        position = helpers.defaultNullOpts.mkEnumFirstDefault [
          "bottom"
          "top"
        ] "";
        margin = helpers.defaultNullOpts.mkNullable spacingOptions {
          top = 1;
          right = 0;
          bottom = 1;
          left = 0;
        } "extra window margin";
        padding = helpers.defaultNullOpts.mkNullable spacingOptions {
          top = 1;
          right = 2;
          bottom = 1;
          left = 2;
        } "extra window padding";
        winblend = helpers.defaultNullOpts.mkNullable (types.ints.between 0
          100
        ) 0 "0 for fully opaque and 100 for fully transparent";
      };

    layout =
      let
        rangeOption = types.submodule {
          options = {
            min = mkOption {
              type = types.int;
              description = "Minimum size.";
            };
            max = mkOption {
              type = types.int;
              description = "Maximum size.";
            };
          };
        };
      in
      {
        height = helpers.defaultNullOpts.mkNullable rangeOption {
          min = 4;
          max = 25;
        } "min and max height of the columns";
        width = helpers.defaultNullOpts.mkNullable rangeOption {
          min = 20;
          max = 50;
        } "min and max width of the columns";
        spacing = helpers.defaultNullOpts.mkInt 3 "spacing between columns";
        align = helpers.defaultNullOpts.mkEnumFirstDefault [
          "left"
          "center"
          "right"
        ] "";
      };

    ignoreMissing = helpers.defaultNullOpts.mkBool false "enable this to hide mappings for which you didn't specify a label";

    hidden = helpers.defaultNullOpts.mkListOf types.str [
      "<silent>"
      "<cmd>"
      "<Cmd>"
      "<CR>"
      "^:"
      "^ "
      "^call "
      "^lua "
    ] "hide mapping boilerplate";

    showHelp = helpers.defaultNullOpts.mkBool true "show a help message in the command line for using WhichKey";

    showKeys = helpers.defaultNullOpts.mkBool true "show the currently pressed key and its label as a message in the command line";

    triggers = helpers.defaultNullOpts.mkNullable (
      with types; either (enum [ "auto" ]) (listOf str)
    ) "auto" "automatically setup triggers, or specify a list manually";

    triggersNoWait =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "`"
          "'"
          "g`"
          "g'"
          "\""
          "<c-r>"
          "z="
        ]
        ''
          list of triggers, where WhichKey should not wait for timeoutlen and show immediately
        '';

    triggersBlackList =
      helpers.defaultNullOpts.mkAttrsOf (types.listOf types.str)
        {
          i = [
            "j"
            "k"
          ];
          v = [
            "j"
            "k"
          ];
        }
        ''
          list of mode / prefixes that should never be hooked by WhichKey
          this is mostly relevant for keymaps that start with a native binding
        '';

    disable = {
      buftypes = helpers.defaultNullOpts.mkListOf types.str [ ] "Disabled by default for Telescope";
      filetypes = helpers.defaultNullOpts.mkListOf types.str [ ] "";
    };
  };

  config =
    let
      cfg = config.plugins.which-key;
      opt = options.plugins.which-key;
      setupOptions = {
        plugins = {
          inherit (cfg.plugins) marks registers spelling;
          presets = {
            inherit (cfg.plugins.presets) operators motions;
            text_objects = cfg.plugins.presets.textObjects;
            inherit (cfg.plugins.presets)
              windows
              nav
              z
              g
              ;
          };
        };
        inherit (cfg) operators;
        key_labels = cfg.keyLabels;
        inherit (cfg) motions icons;
        popup_mappings = {
          scroll_down = cfg.popupMappings.scrollDown;
          scroll_up = cfg.popupMappings.scrollUp;
        };
        window =
          let
            mkSpacing =
              opt:
              helpers.ifNonNull' opt [
                opt.top
                opt.right
                opt.bottom
                opt.top
              ];
          in
          {
            inherit (cfg.window) border position;
            margin = mkSpacing cfg.window.margin;
            padding = mkSpacing cfg.window.padding;
            inherit (cfg.window) winblend;
          };
        inherit (cfg) layout;
        ignore_missing = cfg.ignoreMissing;
        inherit (cfg) hidden;
        show_help = cfg.showHelp;
        show_keys = cfg.showKeys;
        inherit (cfg.settings) spec;
        inherit (cfg) triggers;
        triggers_nowait = cfg.triggersNoWait;
        triggers_blacklist = cfg.triggersBlackList;
        inherit (cfg) disable;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      warnings = optional opt.registrations.isDefined ''
        nixvim (plugins.which-key):
        The option definition `plugins.which-key.registrations' in ${showFiles opt.registrations.files} has been deprecated in which-key v3; please remove it.
        You should use `plugins.which-key.settings.spec' instead.

        Note: the spec format has changed in which-key v3
        See: https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
      '';

      extraConfigLua =
        ''
          require("which-key").setup(${helpers.toLuaObject setupOptions})
        ''
        + (optionalString (opt.registrations.isDefined && cfg.registrations != { }) ''
          require("which-key").register(${helpers.toLuaObject cfg.registrations})
        '');
    };
}
