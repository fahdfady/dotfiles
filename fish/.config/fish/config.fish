function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    set -gx PATH $HOME/.opencode/bin $PATH

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'

    # Arabic/BIDI helper for Kitty:
    # - `rtl` reads stdin and reorders text
    # - `rtl <cmd> [args...]` runs command then reorders its output
    #     function rtl --description 'Reorder UTF-8 text for Arabic RTL in Kitty with Fribidi'
    #         if test (count $argv) -gt 0
    #             $argv | fribidi --charset UTF-8 --nopad --nobreak
    #         else
    #             fribidi --charset UTF-8 --nopad --nobreak
    #         end
    #     end
end

alias kmp0='kitty @ set-spacing padding=10 margin=10'
alias n='kmp0 && nvim '
alias code='code --disable-gpu '

function opencode --description 'Launch opencode with zero kitty padding'
    kitty @ set-spacing padding=0 margin=0
    command opencode $argv
end
