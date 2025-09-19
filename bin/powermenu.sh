#!/usr/bin/env bash

# Power menu options with icons
options="  shutdown
  reboot
  lock
  suspend
  hibernate"

# Show menu using wofi
choice=$(echo -e "$options" | wofi --show dmenu --prompt "power menu")

# Take action based on choice
case "$choice" in
    *""*)  # Shutdown
        systemctl poweroff
        ;;
    *""*)  # Reboot
        systemctl reboot
        ;;
    *""*)  # Lock
        hyprlock
        ;;
    *""*)  # Suspend
        systemctl suspend
        ;;
    *""*)  # Hibernate
        systemctl hibernate
        ;;
esac
