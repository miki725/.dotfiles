function _prompt_git_branch
  echo (git rev-parse --abbrev-ref HEAD 2> /dev/null | awk '{print " (" $1 ")"}')
end

function _elapsed_time
  set -l seconds $argv[1]

  if not test -n "$seconds"
    echo "Must provide time"
    return 1
  end

  if test (echo "$seconds>3600" | bc) -eq 1
    set -l hours (echo "$seconds/3600" | bc)
    set -l minutes (echo "($seconds-(3600*($seconds/3600)))/60" | bc)
    set -l seconds (echo "$seconds -(60*($seconds/60))" | bc)

    if test $hours -gt 1
      set hours_text "hours"
    else
      set hours_text "hour"
    end

    printf '%d %s %d minutes %f seconds' $hours $hours_text $minutes $seconds

  else if test (echo "$seconds>60" | bc) -eq 1
    set -l minutes (echo "$seconds/60" | bc)
    set -l seconds (echo "$seconds -(60*($seconds/60))" | bc)
    printf '%d minutes %f seconds' $minutes $seconds

  else
    echo "$seconds sec"

  end

end

function fish_prompt

  set -l last_status $status

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

  set -l elapsed_color $normal
  if test $last_status -ne 0
    set elapsed_color $red
  end

  set -q CMD_DURATION; and echo $elapsed_color"# elapsed time" (_elapsed_time (echo "$CMD_DURATION/1000" | bc -l))$normal
  echo ''
  echo -s $green$USER$white@$cyan(hostname)$normal ' ' $yellow(prompt_pwd)$normal $purple(_prompt_git_branch)$normal
  echo -s -n $white $_venv
  echo $red'❯'$yellow'❯'$green'❯ '$normal

end
