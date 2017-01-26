# Based on gnzh/muse themes

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst
setopt promptsubst

autoload -U add-zsh-hook

# make some aliases for the colours: (could use normal escape sequences too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

#PROMPT_SUCCESS_COLOR=$FG[117]
PROMPT_SUCCESS_COLOR=$PR_NO_COLOR
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[077]
PROMPT_USER_COLOR=$PR_MAGENTA
PROMPT_PATH_COLOR=$PR_CYAN
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]

# Check the UID
if [[ $UID -ge 1000 ]]; then # normal user
  eval PR_USER='${PROMPT_USER_COLOR}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PROMPT_USER_COLOR}%#${PR_NO_COLOR}'
  local PR_PROMPT='➤ '
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED➤ $PR_NO_COLOR'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH
else
  eval PR_HOST='${PR_MAGENTA}%m${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
#local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'
local current_dir='%{$PROMPT_PATH_COLOR%}%~%{$PR_NO_COLOR%}'
local rvm_ruby=''
if ${HOME}/.rvm/bin/rvm-prompt &> /dev/null; then # detect local user rvm installation
  rvm_ruby='%{$PR_RED%}‹$(${HOME}/.rvm/bin/rvm-prompt i v g s)›%{$PR_NO_COLOR%}'
elif which rvm-prompt &> /dev/null; then # detect sysem-wide rvm installation
  rvm_ruby='%{$PR_RED%}‹$(rvm-prompt i v g s)›%{$PR_NO_COLOR%}'
elif which rbenv &> /dev/null; then # detect Simple Ruby Version management
  rvm_ruby='%{$PR_RED%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$PR_NO_COLOR%}'
fi
#local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'
local git_branch='%{$GIT_PROMPT_INFO%}$(git_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status)'

#PROMPT="${user_host} ${current_dir} ${rvm_ruby} ${git_branch}$PR_PROMPT "
#PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
#╰─$PR_PROMPT "
PROMPT="%{$PROMPT_SUCCESS_COLOR%}╭─%{$reset_color%}${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
%{$PROMPT_SUCCESS_COLOR%}╰─$PR_PROMPT%{$reset_color%} "
RPS1="${return_code}"
#RPROMPT='%{$fg_bold[green]%}%*%{$reset_color%}'
RPROMPT='%{$fg_bold[green]%}$(date +"%l:%M:%S %p")%{$reset_color%}'


#ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_YELLOW%}‹"
#ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$PR_NO_COLOR%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"
