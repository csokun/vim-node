source ~/.git-prompt.sh
PS1='\[\e[32m\]\u\[\e[m\]\[\e[35m\]@\h\[\e[m\]:\w$(__git_ps1 " (%s)")\n $ '

# git
alias gl="git log --graph --pretty=format:'%Cred%h%Creset [%C(magenta)%G?%Creset] -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"