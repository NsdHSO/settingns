# Completions for killport (kill process on port)

# Complete with commonly used ports
complete -c killport -f -a "3000" -d "React/Next.js dev server"
complete -c killport -f -a "4200" -d "Angular dev server"
complete -c killport -f -a "8080" -d "Common development port"
complete -c killport -f -a "8000" -d "Python/Django dev server"
complete -c killport -f -a "5173" -d "Vite dev server"
complete -c killport -f -a "3001" -d "Alternative dev port"
complete -c killport -f -a "5000" -d "Flask/general dev server"
complete -c killport -f -a "9000" -d "PHP/general dev server"
complete -c killport -f -a "4000" -d "Node.js common port"

# Dynamically suggest ports that are currently in use
function __killport_active_ports
    lsof -iTCP -sTCP:LISTEN -nP 2>/dev/null | awk 'NR>1 {split($9,a,":"); print a[length(a)]}' | sort -u
end

complete -c killport -f -a "(__killport_active_ports)" -d "Active port"
