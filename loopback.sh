#!/bin/bash
sink=$(pactl list sinks | grep alsa_output | sed -n 's/.*\bNom.: //p')
source=$(pactl list sources | grep alsa_input | sed -n 's/.*\bNom.: //p')
pactl load-module module-null-sink sink_name=Input
pactl load-module module-combine-sink sink_name=Output slaves=Input,$sink
pactl load-module module-loopback source=$source sink=Input
