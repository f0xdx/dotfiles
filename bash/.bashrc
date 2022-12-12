# Resources
#
# * google bash styleguide: https://google.github.io/styleguide/shellguide.html
# * shellcheck: https://www.shellcheck.net/
# * advanced scripting guide: https://tldp.org/LDP/abs/html/
#
# Thie bashrc works best with the following tools installed on your system
#
#  * fzf
#  * ripgrep (rg)
#  * zoxide
#  * starship
#  * direnv
#  * exa
#  * bat
#  * nvim
#  * tmux
#
#  Apart from that it is optimized for 256 color terminals with a nerdfont

# append to the history file, don't overwrite it
shopt -s histappend

# Environment Variables

export DEFAULT_USER='fheinrichs'
export TERM=xterm-256color
export ENABLE_CORRECTION="false"
export HIST_STAMPS="yyyy-mm-dd"
export PATH=$PATH:$HOME/go/bin:/usr/local/sbin
export NVM_DIR="$HOME/.nvm"
export BAT_THEME="GitHub"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export BASE16_THEME_DARK="tokyo-city-terminal-dark"
export BASE16_THEME_LIGHT="tokyo-city-terminal-light"
export BASE16_THEME_DEFAULT=$BASE16_THEME_LIGHT

export HISTCONTROL=ignoredups:ignorespace:erasedups
export HISTSIZE=10000
export HISTFILESIZE=50000
# export FZF_COMPLETION_AUTO_COMMON_PREFIX=true
# export FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true

# Tools

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"
[ -x "$(command -v rg)" ] && export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init bash)"
[ -x "$(command -v direnv)" ] && eval "$(direnv hook bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Completion

[ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ] && . $(brew --prefix)/etc/profile.d/bash_completion.sh
[ -f "${HOME}/.fzf.bash" ] && _fzf_setup_completion path exa lsx bat nvim.sh

tools=(
  "kubectl"
  "golangci-lint"
)
for tool in "${tools[@]}"; do
  if command -v "$tool" &>/dev/null
  then
    eval "$(${tool} completion bash)"
  fi
done

files=(
  "${HOME}/.config/bash/go.completion.sh"
  "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
  # "${HOME}/.config/fzf-tab-completion/bash/fzf-bash-completion.sh"
)
for file in "${files[@]}"; do
  [[ -f "${file}" ]] && source "${file}"
done

# all-in: fzf completion on tab
# TODO broken and slow, not sure about this ... seems to be a problem of
# readline
# [[ $(type -t fzf_bash_completion) ]] && bind -x '"\t": fzf_bash_completion'

# TODO use better terraform completions - tfenv makes this awkward
complete -C /usr/local/Cellar/tfenv/3.0.0/versions/1.0.9/terraform terraform


# Prompt

[[ -x "$(command -v starship)" ]] && eval "$(starship init bash)"


# Themes

BASE16_SHELL_PATH="$HOME/.config/base16-shell"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL_PATH/profile_helper.sh" ] && \
    source "$BASE16_SHELL_PATH/profile_helper.sh"


# Aliases

alias lsx="exa -T -L1 --color always --icons -s name --group-directories-first"
alias gbc="${HOME}/bin/branch_clean.sh"

[ -f "${HOME}/.config/bash/kubectl_aliases.sh" ] \
  && . "${HOME}/.config/bash/kubectl_aliases.sh" \
  && complete -o default -F __start_kubectl k

# TODO add to dotfiles
# TODO install https://github.com/akinomyoga/ble.sh

# TODO write an updated function that contains those:

# curl -sSf https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/completions/go.completion.sh > go.completion.sh
# curl -sSf https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases > kubectl_aliases.sh
# update vim plugins: nvim +PlugUpdate +qa
# update tmux plugins: ~/.tmux/plugins/tpm/bin/update_plugins all
# should also update all the repos from base16 project
# this includes ~/.config/base16-shell and ~/.config/base16-fzf
# find ~/.config {what we wanna find, i.e., folder with .git repos} -print0 | xargs -0 -P 8 -n 1 {git here}
# https://github.com/lincheney/fzf-tab-completion
update-tools () {
  # update all git based tools
  find "${HOME}/.config" -name .git -type d -not -path "*/plugged/*" -prune -print0 2> /dev/null \
    | sed 's/.git//g' \
    | xargs -0 -P8 -n1 bash -c 'cd "$0"; git pull --rebase'

  # update all single files
  files=(
    "https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/completions/go.completion.sh ${HOME}/.config/bash/go.completion.sh"
    "https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases ${HOME}/.config/bash/kubectl_aliases.sh"
  )
  for file in "${files[@]}"; do
    read -r source target <<<"${file}";
    [[ -f "${target}" ]] && curl -sSf "${source}" > "${target}"
  done

  # update plugins (nvim, tmux)
  [[ -x "$(command -v nvim)" ]] && nvim +PlugUpdate +qa
  [[ -f "${HOME}/.tmux/plugins/tpm/bin/update_plugins" ]] && . "${HOME}/.tmux/plugins/tpm/bin/update_plugins" all
}

# make-it dark (or light)
#
# note: this does not switch teams over, this seems to be handled in its own
# config location; however, simply patching the theme key (defaultV2, darkV2)
# does not work - for now teams has to be switched manually, also requires a
# restart
make-it () {
  export vscode_settings="${HOME}/Library/Application Support/Code/User/settings.json"

  if [ "$1" == "dark" ]; then
    set_theme "$BASE16_THEME_DARK"
    [ -x "$(command -v defaults)" ] && defaults write -g 'AppleInterfaceStyle' -string "Dark"
  else
    set_theme "$BASE16_THEME_LIGHT"
    [ -x "$(command -v defaults)" ] && defaults delete -g 'AppleInterfaceStyle' 
  fi
}

