---
title: "Git prompt with conda and conda-auto-env"
tags: git conda prompt bash conda-auto-env
---

The Git Team maintains a bash script that sets a message in your prompt displaying the current branch and status. The script can be found [here](https://github.com/git/git/tree/master/contrib/completion). To install the script, I have modified the instructions from this [tutorial](https://digitalfortress.tech/tutorial/setting-up-git-prompt-step-by-step/) to make it work with conda and the conda-auto-env tool.

First, we are going to assume that conda is install in our system and we will add conda-auto-env. This tools automatically activates the conda environment every time we `cd` into a folder that has a `env.yml` or `environment.yml` files. There are many versions but in this post I will use the one from [here](https://janosh.io/blog/conda-auto-env/) modified for bash. Download the file `conda_auto_env.sh` to any location in your home folder, for instance `~/scripts`. Then download the script `git-prompt.sh` to the same location and add the following to the **end** of your `~/.bashrc` file:

{% highlight bash %}
GREEN="\[\033[38;5;155m\]"                                                                                                                                                                                                   
DARK_GREEN="\[\033[00;32m\]"                                                                                                                                                                                                 
GRAY="\[\033[38;5;8m\]"                                                                                                                                                                                                      
ORANGE="\[\033[38;5;220m\]"                                                                                                                                                                                                  
BLUE="\[\033[38;5;117m\]"                                                                                                                                                                                                    
WHITE="\[\033[38;5;15m\]"                                                                                                                                                                                                    
YELLOW="\[\033[01;33m\]"                                                                                                                                                                                                     
LIGHT_GRAY="\[\033[0;37m\]"                                                                                                                                                                                                  
CYAN="\[\033[0;36m\]"                                                                                                                                                                                                        
RED="\[\033[0;31m\]"                                                                                                                                                                                                         
VIOLET="\[\033[01;35m\]"                                                                                                                                                                                                     
MAGENTA="\[\033[0;35m\]".                                                                                                                                                                                                    
RESET="\[$(tput sgr0)\]"   

function git_and_conda_prompt {
  local __git_branch_color="$DARK_GREEN"
  local __git_branch=$(__git_ps1 ' [%s]');

  # colour branch name depending on state
  if [[ "${__git_branch}" =~ "*" ]]; then     # if repository is dirty
      __git_branch_color="$RED"
  elif [[ "${__git_branch}" =~ "$" ]]; then   # if there is something stashed
      __git_branch_color="$YELLOW"
  elif [[ "${__git_branch}" =~ "%" ]]; then   # if there are only untracked files
      __git_branch_color="$LIGHT_GRAY"
  elif [[ "${__git_branch}" =~ "+" ]]; then   # if there are staged files
      __git_branch_color="$CYAN"
  fi

  PS1="${CONDA_PROMPT_MODIFIER}${GREEN}\u${RESET}${GRAY}@${RESET}${ORANGE}\h${RESET}${GRAY}:${RESET}${BLUE}\w${RESET}$__git_branch_color$__git_branch${GRAY}\$${RESET}${WHITE}${RESET} "
}

export PROMPT_COMMAND="conda_auto_env;git_and_conda_prompt"

if [ -f ~/scripts/conda_auto_env.sh ]; then
  source ~/scripts/conda_auto_env.sh
fi

# if .git-prompt.sh exists, set options and execute it
if [ -f ~/scripts/git-prompt.sh ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_HIDE_IF_PWD_IGNORED=true
  GIT_PS1_SHOWCOLORHINTS=true
  source ~/scripts/git-prompt.sh
fi
{% endhighlight %}

Let us explain what the previous code does:

  1. Define colors to use for prompt, this will make the `PS1` variable easier to modify
  2. Define a function `git_and_conda_prompt`. We get the git status from `__git_ps1` (provided by `git-prompt.sh`) and color the name of the repository according to the status:
    * `*` unstaged files
    * `$` stashed files
    * `%` untracked files
    * `+` uncommited files
  3. Build the `PS1` variable, this line can be customized by changing the information and colors:
    * `$CONDA_PROMPT_MODIFIER`, current conda environment
    * `\u`: username
    * `\h`: hostname
    * `\w`: working directory
  4. Add `conda_auto_env` (provided by `conda_auto_env.sh`) and `git_and_conda_prompt` to the `$PROMPT_COMMAND` variable. This variable will be executed just before displaying the prompt. The order is important, since we want to activate the environment first (if any) and then display the prompt with all the information.

The variable [`$CONDA_PROMPT_MODIFIER`](https://github.com/conda/conda/issues/1070) is set by `conda activate` and contains the name of the current environment between `()`. `conda init` already shows this information in the prompt by setting the `PS1` variable, however we have to add it manually to since we are overriding `PS1` in the function `git_and_conda_prompt`.  
