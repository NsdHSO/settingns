# This file sources all custom fish functions
for fn in nxg gc gio giofetch giopull ylock yall yas gip gtore ghard ginit yaw killport gis ...
    if test -f ~/.config/fish/functions/$fn.fish
        source ~/.config/fish/functions/$fn.fish
    end
end
