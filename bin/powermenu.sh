#!/usr/bin/env bash

# Power menu options with icons
options="  shutdown
  reboot
  lock
  suspend
  hibernate"

choice=$(echo -e "$options" | fuzzel --dmenu)

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
