#!/usr/bin/env zsh
# SmartZSH Module Manager

# Module loading with dependency resolution
smartzsh_module_load() {
    local module_name="$1"
    local module_path="$SMARTZSH_HOME/modules/$module_name"

    # Check if already loaded
    [[ -n "${SMARTZSH_MODULES[$module_name]}" ]] && return 0

    # Check if module exists
    [[ ! -d "$module_path" ]] && {
        smartzsh_log "error" "Module '$module_name' not found"
        return 1
    }

    # Load module definition
    local module_file="$module_path/module.zsh"
    [[ -r "$module_file" ]] && source "$module_file"

    # Check dependencies
    local deps="${SMARTZSH_MODULE_INFO[$module_name:deps]}"
    if [[ -n "$deps" ]]; then
        local dep
        for dep in ${(s:,:)deps}; do
            smartzsh_module_load "$dep" || return 1
        done
    fi

    # Load module components
    smartzsh_module_load_components "$module_name" "$module_path"

    # Mark as loaded
    SMARTZSH_MODULES[$module_name]="loaded"
    smartzsh_log "debug" "Loaded module: $module_name"
}

# Load module components
smartzsh_module_load_components() {
    local module_name="$1"
    local module_path="$2"

    # Lazy loading check
    if [[ "${SMARTZSH_MODULE_INFO[$module_name:lazy]}" == "true" ]]; then
        smartzsh_setup_lazy_load "$module_name" "$module_path"
        return
    fi

    # Load all .zsh files except module.zsh
    local component
    for component in "$module_path"/*.zsh(N); do
        [[ "$(basename "$component")" != "module.zsh" ]] && source "$component"
    done

    # Run module initialization
    local init_func="smartzsh_${module_name}_init"
    (( $+functions[$init_func] )) && $init_func
}

# Lazy loading setup
smartzsh_setup_lazy_load() {
    local module_name="$1" module_path="$2"
    local trigger_commands="${SMARTZSH_MODULE_INFO[$module_name:trigger]}"

    for cmd in ${(s:|:)trigger_commands}; do
        eval "alias $cmd=\"smartzsh_load_module_components $module_name '$module_path' && unalias $cmd && $cmd\""
    done
}

# Module management commands
smartzsh_module_enable() {
    local module="$1"
    smartzsh_module_load "$module" && {
        local current_modules="${SMARTZSH_CONFIG[modules]}"
        SMARTZSH_CONFIG[modules]="${current_modules:+$current_modules,}$module"
        smartzsh_config_save
    }
}

smartzsh_module_disable() {
    local module="$1"
    unset "SMARTZSH_MODULES[$module]"
    local cleanup_func="smartzsh_${module}_cleanup"
    (( $+functions[$cleanup_func] )) && $cleanup_func
    local modules=(${(s:,:)SMARTZSH_CONFIG[modules]})
    modules=(${modules:#$module})
    SMARTZSH_CONFIG[modules]="${(j:,:)modules}"
    smartzsh_config_save
}
