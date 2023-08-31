#!/bin/bash



 PORTS=(4001 5001 8080 9094 9095 9096 3008)  # Add more port numbers as needed

for PORT in "${PORTS[@]}"; do
    # echo "Killing processes on port $PORT"
    
    # Get a list of PIDs using the current port
    PIDS=$(lsof -t -i :$PORT)
    
    if [ -n "$PIDS" ]; then
        # Terminate the processes
        for PID in $PIDS; do
            echo "Terminating process $PID using port $PORT"
            kill -9 $PID
        done
    else
        echo "No processes found using port $PORT"
    fi
done



# # Get a list of PIDs using the specified port
# PIDS=$(lsof -t -i :4001)

# # Terminate the processes
# for PID in $PIDS; do
#     kill $PID
# done

# # Get a list of PIDs using the specified port
# PIDS=$(lsof -t -i :3008)

# # Terminate the processes
# for PID in $PIDS; do
#     kill $PID
# done

# PIDS=$(lsof -t -i :5001)

# # Terminate the processes
# for PID in $PIDS; do
#     kill $PID
# done