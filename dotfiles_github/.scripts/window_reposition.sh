#!/bin/bash

sleep 6

#[Ferdi]
WINDOW_ID=$(xdotool search --onlyvisible --name ferdi)
xdotool windowsize $WINDOW_ID 1262 1383
xdotool windowmove $WINDOW_ID 6406 45

#[PulseEffects]
WINDOW_ID=$(xdotool search --onlyvisible --name pulseeffects)
xdotool windowsize $WINDOW_ID 1320 760
xdotool windowmove $WINDOW_ID 5100 703

xdotool key XF86AudioPlay