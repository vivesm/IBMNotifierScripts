#!/bin/bash

# IBM Notifier binary paths
NA_PATH="/Applications/IBM Notifier.app/Contents/MacOS/IBM Notifier"

# Variables for the popup notification for ease of customization
WINDOWTYPE="banner" # popup | systemalert | banner | alert | onboarding
BAR_TITLE="Restart Reminder"
TITLE="Your computer has not rebooted for over 30 days"
TIMEOUT="" # leave empty for no notification timeout
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

    local subtitle=$(printf "Your Mac has been running non-stop for %d days! It's time to give it a break and improve its performance. \n\n Save your work and click 'Restart Now' to reboot your Mac." "$days")
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

uptime_data=($(get_uptime))
uptime_days=${uptime_data[0]}

if [[ $uptime_days -ge $DAYS_UPTIME ]]; then
    RESPONSE=$(prompt_user)
    echo "$RESPONSE"

    if [[ $RESPONSE -eq 0 ]]; then
        shutdown -r now
    elif [[ $RESPONSE -eq 2 ]]; then
        exit 1
    fi
fi

exit 0
