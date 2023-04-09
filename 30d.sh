#!/bin/bash

# IBM Notifier binary paths
NA_PATH="/Applications/IBM Notifier.app/Contents/MacOS/IBM Notifier"

# Variables for the popup notification for ease of customization
WINDOWTYPE="popup"
BAR_TITLE="Shelly's Shortcut: Restart Reminder"
TITLE="Your computer has not rebooted for over 30 days"
TIMEOUT="60" # leave empty for no notification time
BUTTON_1="Restart Now"
BUTTON_2="Later"
ICON_PATH="/Users/Shared/cocollective-logo.png"

# Number of seconds in a day
SECONDS_IN_DAY=86400

# Number of days to check for uptime
DAYS_UPTIME=30

### FUNCTIONS ###

# Calculate the number of days, hours, minutes, and seconds the computer has been up
get_uptime() {
    local boot_time=$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')
    local current_time=$(date +%s)
    local uptime_seconds=$((current_time - boot_time))

    local uptime_days=$((uptime_seconds / SECONDS_IN_DAY))
    local uptime_hrs=$((uptime_seconds % SECONDS_IN_DAY / 3600))

    echo "$uptime_days $uptime_hrs $uptime_mins $uptime_secs"
}

# Display a popup notification with the number of days the computer has been up
prompt_user() {
    local uptime=($(get_uptime))
    local days=${uptime[0]}

    local subtitle=$(printf "Wow! Your computer is a fresh %d day champ! But even top performers need a breather. Let's reboot for a snappier, more cheerful machine. \n\n Restart now and unleash the optimization!" "$days")
    button=$("${NA_PATH}" \
        -type "${WINDOWTYPE}" \
        -bar_title "${BAR_TITLE}" \
        -title "${TITLE}" \
        -subtitle "${subtitle}" \
        -icon_path "${ICON_PATH}" \
        -timeout "${TIMEOUT}" \
        -main_button_label "${BUTTON_1}" \
        -secondary_button_label "${BUTTON_2}" \
        -always_on_top)

    echo "$?"
}

### END FUNCTIONS ###

# Example 2 button prompt
RESPONSE=$(prompt_user)
echo "$RESPONSE"

if [[ $RESPONSE -eq 0 ]]; then
    shutdown -r now
elif [[ $RESPONSE -eq 2 ]]; then
    exit 1
fi

exit 0