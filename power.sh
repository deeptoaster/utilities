#!/bin/bash
if [[ $(upower -i $(upower -e | grep AC) | grep online) == *yes* ]]; then
	notify-send "Gestionnaire d'alimentation" "\nVotre Batterie se charge"
	for i in {1..2}; do
		speaker-test -t sine -f 880 & pid=$!
		sleep 0.2
		kill -9 $pid
		sleep 0.1
	done
fi
