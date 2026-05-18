# nighteugene.zsh-theme

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi

PROMPT='%{$fg_no_bold[blue]%}┌[%{$fg_bold[$NCOLOR]%}%n%{$fg_bold[blue]%}@%{$fg_bold[yellow]%}%m%{$fg_no_bold[blue]%}] %{$fg_bold[cyan]%}%~ $(git_prompt_info)
%{$fg_no_bold[blue]%}└> %(?:%{$fg_no_bold[green]%}%1{%(!.#.$)%} :%{$fg_no_bold[red]%}%1{%(!.#.$)%} )%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg[green]%}✔"
