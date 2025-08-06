# SmartZSH - Hook Management System

declare -A SMARTZSH_HOOKS

# Function to add hooks
sz_add_hook() {
  local hook_type=$1
  local function_name=$2
  
  if [[ -z "${SMARTZSH_HOOKS[$hook_type]}" ]]; then
    typeset -ga "${hook_type}"
    SMARTZSH_HOOKS[$hook_type]=1
  fi
  
  eval "${hook_type}+=(\"${function_name}\")"
}

# Function to run hooks
sz_run_hooks() {
  local hook_type=$1
  shift
  
  if [[ -n "${SMARTZSH_HOOKS[$hook_type]}" ]]; then
    for hook in "${(P)hook_type[@]}"; do
      $hook "$@"
    done
  fi
}
