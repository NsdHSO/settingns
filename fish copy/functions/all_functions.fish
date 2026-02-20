# This file sources all custom fish functions
# First load error handling infrastructure
for fn in error_handler check_tool suggest_command
    if test -f ~/.config/fish/functions/$fn.fish
        source ~/.config/fish/functions/$fn.fish
    end
end

# Then load all other functions
for fn in nxg gc gio giofetch giopull ylock yall yas gip gtore ghard ginit yaw killport gis zi zl zr zc zp zconf zhome zdl zdocs penv ... fgb fkill fcd fge fh fzf-check fish_startup_time profile_function profile_startup slow_command_warning show_slow_commands performance_tips perf perf_check quick_perf generate_docs docs auto_update_docs docs_watch add_function_docs session_save session_restore session_list session_delete session_diff session_export session_template theme_switch theme_list theme_preview theme_current
    if test -f ~/.config/fish/functions/$fn.fish
        source ~/.config/fish/functions/$fn.fish
    end
end
