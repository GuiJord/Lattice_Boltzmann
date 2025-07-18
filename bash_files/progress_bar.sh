#!/bin/bash

# Colors
green='\033[0;32m'
gray='\033[1;30m'
reset='\033[0m'

# Arguments
total=$1        # total number of steps (e.g., 100)
current=$2      # current step (e.g., 25)

# Calculate number of # and .
bar_width=70
filled=$(( current * bar_width / total ))
empty=$(( bar_width - filled ))

# Build bar
hashes=$(printf "%0.s#" $(seq 1 $filled))

if (( empty > 0 )); then
    dots=$(printf "%0.s." $(seq 1 $empty))
else
    dots=""
fi
percent=$(( current * 100 / total ))

# Print progress bar
printf "\r[${green}%s${gray}%s${reset}] %d%%" "$hashes" "$dots" "$percent"