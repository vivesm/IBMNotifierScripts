# Restart Reminder

A macOS bash script that checks if the computer has not been rebooted for more than 30 days and prompts the user with a notification to restart their computer.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Integration with JAMF Pro](#integration-with-jamf-pro)

## Features

- Checks the computer's uptime.
- Displays a custom notification if the uptime exceeds 30 days.
- Allows the user to restart their computer immediately or later.

## Requirements

- macOS
- IBM Notifier

## Installation

1. Download the \`restart-reminder.sh\` script.
2. Place the script in a directory of your choice, e.g., \`/usr/local/bin/\`.
3. Make the script executable by running \`chmod +x /usr/local/bin/restart-reminder.sh\`.

## Usage

Run the script manually from the terminal:

```
sh /usr/local/bin/restart-reminder.sh
```

You can also schedule the script to run at a specific time using a tool like \`cron\` or \`launchd\`.

## Integration with JAMF Pro

To integrate this script with JAMF Pro and use an extension attribute:

1. Create a new extension attribute in JAMF Pro with the following settings:
    - Name: \`Uptime Days\`
    - Data Type: Integer
    - Input Type: Script
    - Script: Use the contents of the \`get_uptime()\` function from the \`restart-reminder.sh\` script and modify it to only output the number of days.
2. Create a smart group in JAMF Pro with the following criteria:
    - \`Uptime Days\` is greater than or equal to 30.
3. Create a policy in JAMF Pro that targets the smart group created in step 2.
    - Trigger: Recurring Check-in
    - Execution Frequency: Once per day
    - Add the \`restart-reminder.sh\` script to the policy.

This will run the \`restart-reminder.sh\` script on computers that have not been restarted for 30 days or more.
