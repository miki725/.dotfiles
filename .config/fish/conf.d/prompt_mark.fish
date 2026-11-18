# fish marks prompt starts (OSC 133) for tmux copy mode [ ] jumps but erases the screen right
# after which clears the mark in tmux. mark again on the command line once the prompt is drawn.
# wraps after the prompt as wrapping before would reset $status the prompt shows.
# conf.d runs before config.fish sets up the prompt (starship) so wrap on the first prompt
set -q TMUX; or exit

function __prompt_mark_wrap --on-event fish_prompt
    functions -e __prompt_mark_wrap
    functions -q fish_prompt; or return
    functions -c fish_prompt __prompt_mark_unmarked
    function fish_prompt
        __prompt_mark_unmarked
        printf '\e]133;A\a'
    end
end
