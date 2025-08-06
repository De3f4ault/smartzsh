# SmartZSH - Module Manager

# Global associative array for module metadata and state
declare -A SMARTZSH_MODULES_STATE
declare -a SMARTZSH_LOADED_MODULES

# Function to load a module immediately
smartzsh_load_module() {
    local module_name="$1"
    if [[ "${SMARTZSH_MODULES_STATE[$module_name]}" == "loaded" ]]; then
        return
    fi

    local module_path="$SMARTZSH_MODULES/$module_name/module.zsh"
    if [[ ! -f "$module_path" ]]; then
        return
    fi
    source "$module_path"

    local dependencies="${SMARTZSH_MODULE[dependencies]}"
    if [[ -n "$dependencies" ]]; then
        for dep in ${(s/,/)dependencies}; do
            smartzsh_load_module "$dep"
        done
    fi

    local load_func="sz_${module_name}_load"
    if [[ $(type -w "$load_func") =~ 'function' ]]; then
        "$load_func"
    fi

    SMARTZSH_MODULES_STATE[$module_name]="loaded"
    SMARTZSH_LOADED_MODULES+=("$module_name")
}

# Function to lazy-load a module
smartzsh_lazy_load() {
    local module_name="$1"
    local trigger="$2"

    eval "function ${trigger}() {
        smartzsh_load_module \"$module_name\"
        zle .send-break
        BUFFER=\"\${BUFFER}\"
        zle .accept-line
    }"

    if [[ $trigger == "alias" ]]; then
        local command_list="$3"
        for cmd in ${(s/,/)command_list}; do
            eval "alias \"$cmd\"=\"smartzsh_load_module '$module_name' && $cmd\""
        done
    fi
}

# Main module initialization loop
smartzsh_init_modules() {
  for module_name in ${=SMARTZSH_CONFIG[modules]}; do
      local module_path="$SMARTZSH_MODULES/$module_name/module.zsh"
      if [[ -f "$module_path" ]]; then
          source "$module_path"
          if [[ "${SMARTZSH_MODULE[lazy_load]}" == "true" ]]; then
              smartzsh_lazy_load "$module_name" "sz_load_$module_name"
          else
              smartzsh_load_module "$module_name"
          fi
      fi
  done

  SMARTZSH_END_TIME=$(($(sz_timestamp)))
  SMARTZSH_STARTUP_TIME=$(($SMARTZSH_END_TIME - $SMARTZSH_START_TIME))
  zstyle ':smartzsh:timing' display-time "Startup time: ${SMARTZSH_STARTUP_TIME}ms"
}
