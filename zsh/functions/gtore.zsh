# Interactive git restore for unstaged changes
function gtore() {
  local modified_files=($(git diff --name-only))
  local file_count=${#modified_files[@]}

  if [[ $file_count -eq 0 ]]; then
    echo -e "\033[31m❌ No unstaged changes found.\033[0m"
    return 0
  fi

  # Display modified files
  echo -e "\033[36m📝 Modified files (unstaged):"
  echo "=========================="
  echo -e "\033[33m"
  for i in {1..$file_count}; do
    echo "$i) ${modified_files[$i]}"
  done

  echo -e "\033[34m"
  echo -e "\n📋 Enter the numbers of files to restore (space-separated):"
  echo "Example: 1 3 5 or just 2"
  echo "Press Enter without typing anything to cancel"
  echo -e "\033[0m"

  # Read user input
  read "input?➤ "

  if [[ -z "$input" ]]; then
    echo -e "\033[33m⚠️  No files selected. Exiting...\033[0m"
    return 0
  fi

  # Process selections
  local selected_files=()
  local invalid_selections=()

  for num in ${=input}; do
    if [[ "$num" =~ ^[0-9]+$ ]] && [[ $num -ge 1 ]] && [[ $num -le $file_count ]]; then
      selected_files+=("${modified_files[$num]}")
    else
      invalid_selections+=("$num")
    fi
  done

  # Check for invalid selections
  if [[ ${#invalid_selections[@]} -gt 0 ]]; then
    echo -e "\033[31m❌ Invalid selection(s): ${invalid_selections[*]}"
    echo "Valid range is 1-$file_count\033[0m"
    return 1
  fi

  # Confirm selection
  echo -e "\033[32m"
  echo -e "\n✅ Selected files to restore:"
  echo -e "\033[37m"
  printf "  - %s\n" "${selected_files[@]}"
  echo -e "\033[33m"
  read "confirm?⚠️  Are you sure you want to restore these files? (Y/n): "
  echo -e "\033[0m"

  # Execute restore if confirmed
  if [[ -z "$confirm" ]] || [[ "$confirm" =~ ^[Yy] ]]; then
    echo -e "\033[32m🔄 Restoring selected files..."
    echo -e "\033[36m"
    for file in "${selected_files[@]}"; do
      echo "📄 Restoring: $file"
      git checkout HEAD -- "$file"
    done
    echo -e "\033[32m✨ Done!\033[0m"
  else
    echo -e "\033[33m🚫 Operation cancelled.\033[0m"
  fi
}
