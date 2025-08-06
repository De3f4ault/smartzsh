# SmartZSH - Configuration Engine

# Declare SMARTZSH_CONFIG as a global associative array
# This is crucial for it to correctly store key-value pairs
declare -gA SMARTZSH_CONFIG

# Set default configuration values
SMARTZSH_CONFIG[profile]="default"
SMARTZSH_CONFIG[theme]="default"
SMARTZSH_CONFIG[modules]=""

# Intelligence & Learning defaults
SMARTZSH_CONFIG[learning_enabled]="false"
SMARTZSH_CONFIG[ai_suggestions]="false"
SMARTZSH_CONFIG[context_awareness]="false"
SMARTZSH_CONFIG[workflow_prediction]="false"

# Performance & Monitoring defaults
SMARTZSH_CONFIG[performance_monitoring]="false"
SMARTZSH_CONFIG[startup_profiling]="false"
SMARTZSH_CONFIG[memory_optimization]="false"
SMARTZSH_CONFIG[async_loading]="false"

# Git Integration defaults
SMARTZSH_CONFIG[git_auto_fetch]="false"
SMARTZSH_CONFIG[git_smart_commits]="false"
SMARTZSH_CONFIG[git_workflow_assistance]="false"

# Development Tools defaults
SMARTZSH_CONFIG[docker_integration]="false"
SMARTZSH_CONFIG[kubernetes_support]="false"
SMARTZSH_CONFIG[cloud_tools]="false"
SMARTZSH_CONFIG[version_managers]="false"

# System Administration defaults
SMARTZSH_CONFIG[system_monitoring]="false"
SMARTZSH_CONFIG[ssh_management]="false"
SMARTZSH_CONFIG[service_shortcuts]="false"
SMARTZSH_CONFIG[security_features]="false"

# Visual & UX defaults
SMARTZSH_CONFIG[colored_output]="true"
SMARTZSH_CONFIG[icons]="false"
SMARTZSH_CONFIG[notifications]="true"
SMARTZSH_CONFIG[progress_indicators]="true"

# Navigation & History defaults
SMARTZSH_CONFIG[fuzzy_search]="false"
SMARTZSH_CONFIG[smart_bookmarks]="false"
SMARTZSH_CONFIG[directory_history]="false"
SMARTZSH_CONFIG[per_project_history]="false"

# Productivity Features defaults
SMARTZSH_CONFIG[magic_enter]="false"
SMARTZSH_CONFIG[alias_suggestions]="false"
SMARTZSH_CONFIG[command_completion]="false"
SMARTZSH_CONFIG[file_operations]="false"

# Analytics & Optimization defaults
SMARTZSH_CONFIG[usage_analytics]="false"
SMARTZSH_CONFIG[efficiency_tracking]="false"
SMARTZSH_CONFIG[optimization_suggestions]="false"
