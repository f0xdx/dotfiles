{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    modules.ghostty.enable =
      lib.mkEnableOption "Enables Ghostty terminal emulator configuration.";
  };

  config = lib.mkIf config.modules.ghostty.enable {
    home.packages = [ pkgs.zmx ];

    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      clearDefaultKeybinds = true;

      settings = {
        font-family = "FiraCode Nerd Font"; 
        theme = "light:Modus Operandi,dark:Modus Vivendi";
        font-size = 14;
        confirm-close-surface = false;
        keybind = [
          "ctrl+g>h=goto_split:left"
          "ctrl+g>l=goto_split:right"
          "ctrl+g>k=goto_split:up"
          "ctrl+g>j=goto_split:down"
          "ctrl+g>arrow_down=goto_split:down"
          "ctrl+g>arrow_left=goto_split:left"
          "ctrl+g>arrow_right=goto_split:right"
          "ctrl+g>arrow_up=goto_split:up"
          "ctrl+g>ctrl+h=resize_split:left,14"
          "ctrl+g>ctrl+l=resize_split:right,14"
          "ctrl+g>ctrl+k=resize_split:up,14"
          "ctrl+g>ctrl+j=resize_split:down,14"
          "ctrl+g>ctrl+.=new_split:right"
          "ctrl+g>ctrl+,=new_split:down"
          "ctrl+g>ctrl++=increase_font_size:2"
          "ctrl+g>ctrl+-=decrease_font_size:2"
          "ctrl+g>ctrl+f=toggle_fullscreen"
          "ctrl+g>[=goto_split:previous"
          "ctrl+g>]=goto_split:next"
          "ctrl+g>enter=toggle_split_zoom"
          "ctrl+g>shift+tab=previous_tab"
          "ctrl+g>tab=next_tab"
          "ctrl+g>p=toggle_command_palette"
          "ctrl+g>t=new_tab"
          "ctrl+g>w=new_window"
          "ctrl+g>q=close_surface"

          "ctrl+shift+page_down=jump_to_prompt:1"
          "ctrl+shift+page_up=jump_to_prompt:-1"
          "ctrl+shift+a=select_all"
          "ctrl+shift+c=copy_to_clipboard:mixed"
          "ctrl+shift+f=start_search"
          "ctrl+shift+i=inspector:toggle"
          "ctrl+shift+j=write_screen_file:paste,plain"
          "ctrl+shift+q=quit"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+w=close_tab:this"
          "alt+digit_1=goto_tab:1"
          "alt+digit_2=goto_tab:2"
          "alt+digit_3=goto_tab:3"
          "alt+digit_4=goto_tab:4"
          "alt+digit_5=goto_tab:5"
          "alt+digit_6=goto_tab:6"
          "alt+digit_7=goto_tab:7"
          "alt+digit_8=goto_tab:8"
          "alt+1=goto_tab:1"
          "alt+2=goto_tab:2"
          "alt+3=goto_tab:3"
          "alt+4=goto_tab:4"
          "alt+5=goto_tab:5"
          "alt+6=goto_tab:6"
          "alt+7=goto_tab:7"
          "alt+8=goto_tab:8"
          "alt+9=last_tab"
          "alt+f4=close_window"
          "ctrl++=increase_font_size:1"
          "ctrl+-=decrease_font_size:1"
          "ctrl+0=reset_font_size"
          "ctrl+enter=toggle_fullscreen"
          "ctrl+==increase_font_size:1"
          "ctrl+insert=copy_to_clipboard:mixed"
          "ctrl+page_down=next_tab"
          "ctrl+page_up=previous_tab"
          "shift+end=scroll_to_bottom"
          "shift+home=scroll_to_top"
          "shift+insert=paste_from_selection"
          "shift+page_down=scroll_page_down"
          "shift+page_up=scroll_page_up"
          "shift+arrow_down=adjust_selection:down"
          "shift+arrow_left=adjust_selection:left"
          "shift+arrow_right=adjust_selection:right"
          "shift+arrow_up=adjust_selection:up"
          "performable:escape=end_search"
          "performable:copy=copy_to_clipboard:mixed"
          "performable:paste=paste_from_clipboard"
        ];
        window-save-state = "always";
      };

      systemd.enable = ! pkgs.stdenv.isDarwin;
    };

    programs.bash.initExtra = ''
      # zmx completions
      if command -v zmx &> /dev/null; then
        eval "$(zmx completions bash)"
      fi

      # fzf session picker (zmx-select)
      zmx-select() {
        local display
        display=$(zmx list 2>/dev/null | while IFS=$'\t' read -r name pid clients created dir; do
          name=''${name#session_name=}
          pid=''${pid#pid=}
          clients=''${clients#clients=}
          dir=''${dir#started_in=}
          printf "%-20s  pid:%-8s  clients:%-2s  %s\n" "$name" "$pid" "$clients" "$dir"
        done)

        local output query key selected session_name
        output=$({ [[ -n "$display" ]] && echo "$display"; } | fzf \
          --print-query \
          --expect=ctrl-n \
          --height=80% \
          --reverse \
          --prompt="zmx> " \
          --header="Enter: select | Ctrl-N: create new" \
          --preview='zmx history {1}' \
          --preview-window=right:60%:follow \
        )

        readarray -t results <<< "$output"
        query=''${results[0]}
        key=''${results[1]}
        selected=''${results[2]}

        if [[ "$key" == "ctrl-n" ]]; then
          if [[ -n "$query" ]]; then
            zmx attach "$query"
          else
            read -p "Session name: " name
            [[ -n "$name" ]] && zmx attach "$name"
          fi
        elif [[ -n "$selected" ]]; then
          session_name=$(echo "$selected" | awk '{print $1}')
          zmx attach "$session_name"
        fi
      }
    '';
  };
}

