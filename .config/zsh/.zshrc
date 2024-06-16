# Lines configured by zsh-newuser-install

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

HISTSIZE=50000
SAVEHIST=$HISTSIZE

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time
#

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

autoload -Uz compinit
compinit
# End of lines added by compinstall

#WMSESSION=x11  #wayland or x11

# autoload -Uz promptinit
# promptinit 
# End of lines added by compinstall
# autoload -U colors && colors

source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
[[ -f "$ZDOTDIR/.zshrc_prompt" ]] && source "$ZDOTDIR/.zshrc_prompt"

# GIT_PS1_SHOWUPSTREAM="auto"
# GIT_PS1_SHOWCOLORHINTS="yes"
# GIT_PS1_SHOWDIRTYSTATE=true
# GIT_PS1_SHOWUNTRACKEDFILES=true
# GIT_PS1_SHOWSTASHSTATE=true
# setopt PROMPT_SUBST

RED='%F{red}'
GREEN='%F{green}'
BLANK='%f'
gitUpstreamPosition() {
    local commitCount=$(git rev-list --count --left-right @{upstream}...HEAD 2> /dev/null)
    if [ -n "$commitCount" ]; then
       local behindCount=$(echo -n "$commitCount" | cut -f1)
       local aheadCount=$(echo -n "$commitCount" | cut -f2)
       if [ "$behindCount" != "0" ]; then
           echo -n " ${behindCount}↓"
       fi
       if [ "$aheadCount" != "0" ]; then
          echo -n " ${aheadCount}↑"
       fi
    fi
}
gitStatusSymbols() {
    local gitstatus=$(git status --porcelain 2> /dev/null)
    if [ -n "$gitstatus" ]; then
		 local addcnt=""
		 local modifiedcnt=""
		 local untrackedcnt="";
         local addedFiles=$(echo "$gitstatus" | grep '^[^? ]' | wc -l)
         local modifiedFiles=$(echo "$gitstatus" | grep '^.[^? ]' | wc -l)
         local untrackedFiles=$(echo "$gitstatus" | grep '^[?][?]' | wc -l)
         if [ "$addedFiles" -gt 0 ]; then
                addcnt="暂存:$statusString$GREEN$addedFiles$BLANK"
         fi
         if [ "$modifiedFiles" -gt 0 ]; then
                modifiedcnt="修改:$statusString$RED$modifiedFiles$BLANK"
         fi
         if [ "$untrackedFiles" -gt 0 ]; then
                untrackedcnt="未跟踪:$statusString$untrackedFiles"
         fi
         echo -e "$addcnt$modifiedcnt$untrackedcnt"
    fi
}
gitPrompt() {
    local branchName=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ -n "$branchName" ]; then
       echo -e " [分支：${branchName} $(gitStatusSymbols) $(gitUpstreamPosition)]"
    fi
}
setopt PROMPT_SUBST
# Prompt
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
#PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
