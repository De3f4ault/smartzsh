# SmartZSH - Analytics Module (SQLite-backed)

# Function to display basic performance statistics
sz_analytics_report() {
    echo "📊 SmartZSH Analytics Report"
    echo "----------------------------"

    echo "Top 10 Most Used Commands:"
    sz_db_query "SELECT command, COUNT(*) AS count FROM command_history GROUP BY command ORDER BY count DESC LIMIT 10;"

    echo ""
    echo "Average Command Duration (ms):"
    sz_db_query "SELECT AVG(duration_ms) FROM command_history WHERE duration_ms IS NOT NULL;"

    echo ""
    echo "Total Commands Executed:"
    sz_db_query "SELECT COUNT(*) FROM command_history;"

    echo ""
    echo "Top 10 Most Visited Directories:"
    sz_db_query "SELECT path, visits FROM directory_visits ORDER BY visits DESC LIMIT 10;"
}

# Function to clear analytics data (for testing/reset)
sz_analytics_clear() {
    echo "Clearing all analytics data..."
    sz_db_exec "DELETE FROM command_history;"
    sz_db_exec "DELETE FROM directory_visits;"
    echo "Analytics data cleared."
}

# Add a CLI command for analytics
# This would be integrated into bin/sz (see below)
# For now, define a direct alias for testing
alias szstats='sz_analytics_report'
alias szclearstats='sz_analytics_clear'
