#!/bin/sh
#
# Author:       bbn
# 
# Description:  It checks current battery level and its charging status, and sends a desktop notification 
#               in a case when level is lower than specified threshold and discharing 
#               and in a case when the level is higher than given threshold and charging
# 
# Created:      2015-01-18
# Updated:      2016-10-21

# Send a notification and play sound
notify() {
    # send notification
    /usr/bin/notify-send "$1" "$2"

    # play sound
    sound=/usr/share/sounds/gnome/default/alerts/drip.ogg
    /usr/bin/paplay $sound
}

# Check given value and return it back if present, otherwise return given default value
check_value() {
    # $1 - value to test
    # $2 - given default value

    if [ ! -z "$1" ]; then
        echo $1
    else
        echo $2
    fi
}

threshold_low=$(check_value "$1" "20") 
threshold_high=$(check_value "$2" "99")
output_log=$(check_value "$3" "/dev/null")

# Take current battery level in numeric value
battery_level=`/usr/bin/acpi -b | grep -P -o '[0-9]+(?=%)'`

# Battery charging status, a text in lower case
battery_state=`/usr/bin/acpi -b | grep -P -o '[a-zA-Z]+(?=,)' | tr 'A-Z' 'a-z'`

message="Battery is ${battery_state} at level ${battery_level}%!"

# Battery level is higher than threshold and still charging
if [ $battery_level -gt $threshold_high -a $battery_state == "charging" ]; then
    notify "Battery full, unplug from power" "$message"
# Battery level is lower than threshold and still discharging
elif [ $battery_level -lt $threshold_low -a $battery_state == "discharging" ]; then
    notify "Battery low, plug to power source" "$message"
fi

echo -e "$(date +"%Y-%m-%d %H:%M:%S") \t $message" >> $output_log

exit 0
