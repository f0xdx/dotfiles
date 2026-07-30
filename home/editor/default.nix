{
  config,
  lib,
  ...
}: {
  imports = [
    ./nvim
    ./zed
    ./emacs
  ];

  options = {
    modules.editor = {
      default = lib.mkOption {
        type = lib.types.enum ["emacs" "nvim" "zed"];
        default = "emacs";
        description = "Preferred default CLI and GUI editor for sessionVariables (EDITOR/VISUAL).";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion =
          (config.modules.editor.default == "emacs" -> config.modules.emacs.enable)
          && (config.modules.editor.default == "nvim" -> config.modules.nvim.enable)
          && (config.modules.editor.default == "zed" -> config.modules.zed.enable);
        message = "modules.editor.default is set to '${config.modules.editor.default}', but modules.${config.modules.editor.default}.enable is false.";
      }
    ];

    home.sessionVariables = lib.mkMerge [
      (lib.mkIf (config.modules.editor.default == "emacs") {
        ALTERNATE_EDITOR = "";
        EDITOR = "emacsclient -t -a ''";
        VISUAL = "emacsclient -c -a ''";
      })
      (lib.mkIf (config.modules.editor.default == "nvim") {
        EDITOR = "nvim";
        VISUAL = "nvim";
      })
      (lib.mkIf (config.modules.editor.default == "zed") {
        EDITOR = "zed --wait";
        VISUAL = "zed --wait";
      })
    ];
  };
}
