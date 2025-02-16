#!/bin/bash

# Function to print a header
print_header() {
    echo -e "\n$1:"
}

# Function to get top 5 entries
get_top_5() {
    local field=$1
    local label=$2
    
    # Using awk to extract the field, then sort and count unique occurrences
    awk "{print \$$field}" "$log_file" | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -n 5 | \
    awk "{printf \"%s - %d requests\\n\", \$2, \$1}"
}

# Function to get top 5 paths (requires special handling due to quotes)
get_top_paths() {
    # Extract the request path (field 7), remove quotes, sort, count, and display top 5
    awk '{print $7}' "$log_file" | \
    tr -d '"' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -n 5 | \
    awk '{printf "%s - %d requests\n", $2, $1}'
}

# Function to get top 5 user agents
get_top_agents() {
    # Extract everything from field 12 to end (user agent), sort, count, and display top 5
    awk '{for(i=12;i<=NF;i++) printf "%s ", $i; print ""}' "$log_file" | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -n 5 | \
    awk '{printf "%s - %d requests\n", substr($0, index($0,$2)), $1}'
}

# Check if log file is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <nginx-log-file>"
    exit 1
fi

log_file="$1"

# Check if file exists
if [ ! -f "$log_file" ]; then
    echo "Error: File $log_file does not exist"
    exit 1
fi

# Print top 5 IP addresses
print_header "Top 5 IP addresses with the most requests"
get_top_5 1 "IP"

# Print top 5 paths
print_header "Top 5 most requested paths"
get_top_paths

# Print top 5 status codes
print_header "Top 5 response status codes"
get_top_5 9 "Status"

# Print top 5 user agents
print_header "Top 5 user agents"
get_top_agents