#!/bin/bash

# Define an array of service directories and their corresponding start scripts
services=(
    "./startup.sh"
    "./script.sh"
    # Add more services as needed
)
    
# Loop through the services array and start each service in a new xterm window
for service in "${services[@]}"; do
    directory="${service%%:*}"
    start_script="${service#*:}"

    # Start the service in the background
    ("./$start_script" &)  # & puts the process in the background
done