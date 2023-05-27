
# run idle script

# Define the number of consecutive checks required for idle state
consecutive_checks=30

# Define the threshold for CPU load (change as needed)
threshold=0.1

# Initialize idle check counter
idle_counter=0

# Check CPU usage and idle state
while true; do
    
  # Get the CPU load average for the past 1 minute
  load_average=$(uptime | sed -e 's/.*load average: //g' | awk '{ print $1 }') # 1-minute average load
  load_average="${load_average//,}" # remove trailing comma

  # Check if CPU load is below the threshold
  if (( $(echo "$load_average < $threshold" | bc -l) )); then
    idle_counter=$((idle_counter + 1))
    echo "CPU load is below the threshold. Idle counter: $idle_counter"
  else
    idle_counter=0
    echo "CPU load is above the threshold. Resetting idle counter."
  fi
  
  # Check if the idle counter reaches the consecutive check limit
  if [ $idle_counter -ge $consecutive_checks ]; then
    echo "The CPU has been idle for $consecutive_checks consecutive checks. Shutting down..."
    sudo poweroff
    exit 0
  fi
  
 
  sleep 60
done
