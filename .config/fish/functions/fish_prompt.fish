function _promtp_git_branch
  echo (git rev-parse --abbrev-ref HEAD 2> /dev/null | awk '{print " (" $1 ")"}')
end

function fish_prompt
	
  # set -l last_status $status
 
  # Just calculate these once, to save a few cycles when displaying the prompt
  # if not set -q __fish_prompt_hostname
  #   set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  # end
  # if not set -q __fish_prompt_char
  #   switch (id -u)
  #     case 0
  #   set -g __fish_prompt_char '#'
  #     case '*'
  #   set -g __fish_prompt_char '>'
  #   end
  # end
 
  # Setup colors
  set -l normal (set_color normal)
  set -l red (set_color red)
  # set -l yellow (set_color yellow)
  set -l yellow (set_color FFFF00)
  set -l green (set_color green)
  set -l cyan (set_color cyan)
  set -l white (set_color white)
  set -l gray (set_color -o cyan)
  set -l purple (set_color -o purple)
  set -l brwhite (set_color -o white)
 
  # Configure __fish_git_prompt
  # set -g __fish_git_prompt_showdirtystate false
  # set -g __fish_git_prompt_showuntrackedfiles false
  # set -g __fish_git_prompt_showstashstate false
  # set -g __fish_git_prompt_color purple
  # set -g __fish_git_prompt_color_flags purple
 
  # Color prompt char red for non-zero exit status
  # set -l pcolor $gray
  # if test $last_status -ne 0
  #   set pcolor $red
  # end
 
  set -l _venv ''
  if set -q VIRTUAL_ENV
  	set _venv "("(basename "$VIRTUAL_ENV" '')") "
  end

  echo ''
  echo -s $green$USER$white@$cyan(hostname)$normal ' ' $yellow(prompt_pwd)$normal $purple(_promtp_git_branch)$normal
  echo -s -n $white $_venv
  echo $red'❯'$yellow'❯'$green'❯ '$normal

end
