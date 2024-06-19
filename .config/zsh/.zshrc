setopt printexitvalue

setopt CORRECT

autoload -U colors && colors

# history
HISTFILE=$XDG_DATA_HOME/zsh_history
SAVEHIST=50000
HISTSIZE=20000

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

# Completion
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# case-insensitive, allow completion from the middle of a word
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*' menu select=1

autoload -Uz compinit && compinit -d $HOME/.cache/zcompdump
# End of lines added by compinstall

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

[ -f "$XDG_CONFIG_HOME/shell/aliasrc" ] && source "$XDG_CONFIG_HOME/shell/aliasrc"

[ -f "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
[ -f "$ZDOTDIR/.zshrc_prompt" ] && source "$ZDOTDIR/.zshrc_prompt"
[ -f "$ZDOTDIR/config/git.zsh" ] && source $ZDOTDIR/config/git.zsh
[ -f "$ZDOTDIR/config/keys.zsh" ] && source $ZDOTDIR/config/keys.zsh

# Prompt:
# [VI_MODE] username@hostname cwd % (git-branch)
setopt prompt_subst

function collapsed_curdir() {
  local i pwd
  pwd=("${(s:/:)PWD/#$HOME/~}")
  if (( $#pwd >1 )); then
    for i in {1..$(($#pwd-1))}; do
      if [[ "$pwd[$i]" = .* ]]; then
        pwd[$i]="${${pwd[$i]}[1,2]}"
      else
        pwd[$i]="${${pwd[$i]}[1]}"
      fi
    done
  fi
  echo "${(j:/:)pwd}"
}

function custom_color() {
  # 输出50~200
  echo $(( $(($(date +%s%N) % 60)) + 50 ))
}
#PROMPT='%B%F{magenta}%n%B%F{cyan}%n%m%k %B%F{yellow}%1~%# %b%f%k'
my_prompt="%B%F{$(custom_color)}%n%b%f%B%F{$(custom_color)}@%B%F{$(custom_color)}%m%f%k:%B%F{$(custom_color)}"
PROMPT='${my_prompt}$(collapsed_curdir) %b%f%k 
🦊 '   #😏🐼
RPROMPT='$(gitPrompt)'


