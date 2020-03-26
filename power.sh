#!/bin/bash
export DISPLAY=:0.0
eval "export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep xfce4-session)/environ)"
if [[ $(upower -i $(upower -e | grep AC) | grep online) == *yes* ]]; then
	notify-send "Gestionnaire d'alimentation" "\nVotre Batterie se charge"
	for i in {1..2}; do
		speaker-test -t sine -f 880 & pid=$!
		sleep 0.2
		kill -9 $pid
		sleep 0.1
	done
fi
