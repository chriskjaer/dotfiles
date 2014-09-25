ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""

function prompt_char {
  if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL: $?%{$reset_color%})
%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}: %{$fg[blue]%}%~
%{$reset_color%}$(git_prompt_info)%_$(prompt_char) '

RPROMPT='%{$fg[gray]%}[%*]%{$reset_color%}'

ZSH_THEME_TERM_TAB_TITLE_IDLE="%50<..<%c%<<" #20 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%~"
