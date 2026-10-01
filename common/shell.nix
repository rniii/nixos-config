{
    programs.fish = {
        enable = true;
        promptInit = ''
            set -g fish_color_command --reset
            set -g fish_color_param --reset

            function fish_prompt
                echo -n -s \
                    (set_color magenta --bold) (prompt_hostname) " " \
                    (set_color cyan --reset) (prompt_pwd) (fish_vcs_prompt) "> " \
                    (set_color --reset)
            end

            function fish_right_prompt
                set -l lastpipestatus $pipestatus
                __fish_print_pipestatus \
                    "" " :<" "|" (set_color red) (set_color --bold) \
                    $lastpipestatus
            end
        '';
    };
}
