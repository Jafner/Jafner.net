#!/bin/bash

#sleep 6

WINDOW_ID=$(xdotool search --onlyvisible --name ferdi)
xdotool windowsize $WINDOW_ID 1262 1317
xdotool windowmove $WINDOW_ID 6406 11

WINDOW_ID=$(xdotool search --onlyvisible --name pulseeffects)
xdotool windowsize $WINDOW_ID 1314 715 
xdotool windowmove $WINDOW_ID 5106 676

WINDOW_ID=$(xdotool search --onlyvisible --name spot)
xdotool windowsize $WINDOW_ID 1290 704
xdotool windowmove $WINDOW_ID 5118 0

