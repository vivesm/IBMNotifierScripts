#!/bin/bash

# IBM Notifier binary paths
NA_PATH="/Applications/IBM Notifier.app/Contents/MacOS/IBM Notifier"

# Variables for the popup notification for ease of customization
WINDOWTYPE="systemalert"
BAR_TITLE="macOS Update Reminder"
TITLE="A new macOS update is available"
TIMEOUT=""
BUTTON_1="Update"
BUTTON_2="Later"
ICON_PATH="/Users/Shared/cocollective-logo.png"

# macOS version to check against
REQUIRED_VERSION="13.3.3"

### FUNCTIONS ###

get_macos_version() {
    sw_vers -productVersion
}

version_compare() {
    [[ $1 = $2 ]] && echo 0
    [[ $1 != $2 && $1 = $(echo -e "$1\n$2" | sort -V | head -n1) ]] && echo -1 || echo 1
}

prompt_user() {
    local subtitle="A new macOS update is available. Please update your system to improve security and performance. Click 'Update' to open Software Update in System Settings."

    button_output=$("${NA_PATH}" \
        -type "${WINDOWTYPE}" \
        -bar_title "${BAR_TITLE}" \
        -title "${TITLE}" \
        -subtitle "${subtitle}" \
        -icon_path "${ICON_PATH}" \
        -timeout "${TIMEOUT}" \
        -main_button_label "${BUTTON_1}" \
        -secondary_button_label "${BUTTON_2}" \
        -always_on_top 2>/dev/null)

    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "$button_output" | awk -F'button:' '{print $2}'
    else
        echo "Error: Failed to display notification." >&2
        exit 1
    fi
}

### END FUNCTIONS ###

current_version=$(get_macos_version)
echo "Current macOS version: $current_version"
echo "Required macOS version: $REQUIRED_VERSION"

comparison_result=$(version_compare "$current_version" "$REQUIRED_VERSION")

if [[ "$comparison_result" -lt 0 ]]; then
    RESPONSE=$(prompt_user)
    echo "User response: $RESPONSE" >&2

    if [[ $RESPONSE -eq 0 ]]; then
        echo "Opening Software Update in System Preferences..." >&2
        open "x-apple.systempreferences:com.apple.preferences.softwareupdate"
    elif [[ $RESPONSE -eq 2 ]]; then
        echo "User selected 'Later', exiting script with exit code 1." >&2
        exit 1
    else
        echo "Error: Unexpected user response value." >&2
        exit 1
    fi
else
    echo "macOS version meets the requirement. No action needed."
fi

echo "Script finished."
exit 0
