+++
title = 'Pamidi: Control PulseAudio with a MIDI device'
description = 'In this article I review the script I wrote in 2021 to manipulate PulseAudio with a MIDI controller.'
date = 2024-05-28T17:58:19-07:00
draft = false
ogimage = "pamidi.logo.png"
slug = 'pamidi'
+++

{{< image src="pamidi.jpg" >}}

My first project posted publicly. Initially I didn't expect to post it, but I didn't see any other solutions to the problem I was having, so I figured my solution could inspire someone else to do it better.

# Problem: Physical Volume Knobs for Applications
While using Windows, I installed an application called [MIDI Mixer](https://www.midi-mixer.com/) to map the physical volume knobs of my [Behringer X-Touch Mini](https://www.behringer.com/product.html?modelCode=0808-AAF) (and the accompanying mute and media control buttons) to individual applications on my PC. The most common use-case for me was turning my Spotify music up or down without alt-tabbing from my Overwatch game. My microphone was also mapped into the software. 

It's just nice to have a physical interface for these things. But when I tried switching to Pop!_OS a couple years ago, I first [inquired at /r/linuxaudio](https://www.reddit.com/r/linuxaudio/comments/owqi6j/linux_equivalent_to_midi_mixer_functionality/) about replicating that functionality on Linux. While I was able to find [a similar project](https://github.com/solarnz/pamidicontrol), nothing really scratched the itch, so I dug in to build my own. 

# Solution: PulseAudio and Xdotool in a Bash Script
I built [`pamidi`](https://github.com/Jafner/pamidi). We'll break it down here, with the benefit of retrospect. 

## Dependencies
Two utilities are critical to the function of the script: [`xdotool`](https://github.com/jordansissel/xdotool) and [`pacmd`](https://man.archlinux.org/man/pacmd.1). Additionally, we presume you're running SystemD with PulseAudio.

- `xdotool` is used to get the current focused window. This lets us drastically simplify the UX of mapping the volume knobs to specific applications. 
- `pacmd` is used to change volume and toggle mute for PulseAudio streams. 

## Code Breakdown
Let's take a look at [the code](https://github.com/Jafner/pamidi/blob/main/pamidi.sh). The source is annotated with comments, but we'll just look at the code here.

### Initialize the Service
```bash
initialize(){
	echo "Initializing"
	echo "Checking for xdotool"
	if ! hash xdotool &> /dev/null; then
		echo "xdotool could not be found, exiting"
		exit 2
	else
		echo "xdotool found"
	fi
	echo "Waiting for pulseaudio service to start..."
	while [[ $(systemctl --machine=joey@.host --user is-active --quiet pulseaudio) ]]; do
		echo "Pulseaudio service not started, waiting..."
		sleep 2
	done
	echo "Waiting for X-TOUCH MINI to be connected..."
	while [[ ! $(lsusb | grep "X-TOUCH MINI") ]]
	do
		echo "X-TOUCH MINI not connected. Waiting..."
		sleep 2
	done 
	col_1_app_pid=-1
	col_2_app_pid=-1
	col_3_app_pid=-1
	col_4_app_pid=-1
	col_5_app_pid=-1
	col_6_app_pid=-1
	col_7_app_pid=-1
	col_8_app_pid=-1
	assign_profile_1
	print_col_app_ids
	echo "Initialized pamidi"
	notify-send "Initialized pamidi"
}
```

1. First we check to ensure `xdotool` is installed. `hash` is a weird choice for checking the presence of a command. Would probably use `which` today. 
2. Next we wait until we see that the PulseAudio SystemD unit's status is "active". But, uh... I'm not sure why I needed that `--machine=joey@.host` flag. 
3. We wait until `lsusb` reports the `X-TOUCH MINI` as connected.
4. We set up our 8 variables for storing application PIDs. 
5. We invoke a yet-to-be-implemented function `assign_profile_1`. It does nothing.
6. We print the PIDs bound to each knob to the console. And then we send an OS notification that the service is initialized. 

Cool. Now how does it actually work?

### Change Volume: Mackie vs. Standard
```bash
change_volume_mackie() {
	if (( $2 >= 64 )); then
		vol_change="-$(expr $2 - 64)"
	else
		vol_change="+$2"
	fi

	app_pid=$1

	all_sink_inputs="$(pacmd list-sink-inputs)"
	all_sink_inputs="$(paste \
		<(printf '%s' "$all_sink_inputs" | grep 'application.process.id' | cut -d'"' -f 2) \
		<(printf '%s' "$all_sink_inputs" | grep 'index: ' | rev | cut -d' ' -f 1 | rev))"

	echo "$all_sink_inputs" | while read line ; do
		pid=$(echo "$line" | cut -f1)
		if [[ "$pid" == "$1" ]]; then
			stream_id="$(echo "$line" | cut -f2)"
			pactl set-sink-input-volume $stream_id $vol_change% 2> /dev/null
		fi
	done
}
```

1. We take two positional arguments for this function: application PID, and volume delta.
   - The use of volume delta is the primary differentiator between Mackie mode and standard mode. In Mackie mode, turning the knob returns a *change* in volume. Values from 0-63 represent `-63` through `-1` and values from 64-127 represent `+0` through `+63`. We use this to set a `volume_change` variable.
2. In order to change volume, we need the sink ID matching the PID for the application we've bound to a particular knob. We do this in a very roundabout way. 
   1. We get a list of all PulseAudio sink-inputs (playback streams) with their detailed properties. We need the index (sink ID) and application process ID (our PID). 
   2. We do some pipe gymnastics to convert that to an array of tuples in the form `<sink-id> <application-pid>`. Then we iterate over that list to match the provided application PID. 
3. Lastly, we use `pactl set-sink-input-volume` to change the volume.
    - `$stream_id` determines which sink-input is affected. Like `4`.
    - `$vol_change` is a string of a signed integer in `|0-63|`. Like `-12` or `+62`

Note: In Standard mode, we use the same `pactl` command, but the volume argument is prepended with a sign to increment/decrement the volume, rather than set it.

### Toggle Mute, Mute On, and Mute Off
Instead of posting the full functions, which are highly repetitive, we'll just look at how they differ from each other.

We follow the same process as in change volume to get the stream ID from the PID. 

- Toggle mute: `pactl set-sink-input-mute $stream_id toggle`
- Mute on: `pactl set-sink-input-mute $stream_id on`
- Mute off: `pactl set-sink-input-mute $stream_id off`

### Get Stream Index from PID
```bash
get_stream_index_from_pid(){
	all_sink_inputs="$(pacmd list-sink-inputs)"
	all_sink_inputs="$(paste \
		<(printf '%s' "$all_sink_inputs" | grep 'application.process.id' | cut -d'"' -f 2) \
		<(printf '%s' "$all_sink_inputs" | grep 'index: ' | rev | cut -d' ' -f 1 | rev))"

	stream_ids=""
	echo "$all_sink_inputs" | while read line ; do
		pid=$(echo "$line" | cut -f1)
		if [[ "$pid" == "$1" ]]; then
			echo "$line" | cut -f2
		fi
	done
}
```
This function does all the gymnastics we repeat in every other function. We just don't use this function anywhere in the code.

### Get Binary from PID
```bash
get_binary_from_pid(){
	output="$(paste -d"\t" \
		<(printf '%s' "$output" | grep 'application.process.id' | cut -d'"' -f 2) \
		<(printf '%s' "$output" | grep 'application.process.binary' | cut -d'"' -f 2))"

	echo "$output" | while read line ; do
		pid=$(echo "$line" | cut -f1)
		if [[ "$pid" == "$1" ]]; then
			echo "$line" | cut -f2
		fi
	done
}
```
This function is not used anywhere. It requires that `$output` contain the raw response from `pactl list-sink-inputs`. It creates an array of tuples in the form `<pid> <application binary>`, and then prints the name of the application binary matching the PID passed to the function as the first positional argument. 

### Bind Application
```bash
bind_application() {
	window_pid="$(xdotool getactivewindow getwindowpid)"
	window_name="$(xdotool getactivewindow getwindowname)"
	col_id=$1
	case "$col_id" in
		"1" ) col_1_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"2" ) col_2_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"3" ) col_3_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"4" ) col_4_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"5" ) col_5_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"6" ) col_6_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"7" ) col_7_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
		"8" ) col_8_app_pid=$window_pid && notify-send "Set knob $col_id to $window_name" ;;
	esac

}
```
This function is called when we press down on one of the knobs. It binds the currently focused application to that knob. Very nice UX, and reletively simply implemented. It takes the index of the knob pressed as its one positional argument.

1. Use `xdotool` to get the pid and name of the currently active window.
2. Assign the window PID to that knob, and send an OS notification to let the user know what happened.

### Main: Mackie and Standard
```bash
main_mackie(){
	aseqdump -p "X-TOUCH MINI" | \
	while IFS=" ," read src ev1 ev2 ch label1 data1 label2 data2 rest; do
		case "$ev1 $ev2 $data1 $data2" in 
			# column 1
			"Note on 32"* ) bind_application 1 ;; # knob press
		    "Note on 89"* ) toggle_mute $col_1_app_pid ;; # top button
			"Note on 87"* ) print_col_app_ids ;; # bottom button
			"Control change 16"* ) change_volume $col_1_app_pid $data2 ;; # knob turn

			# column 2
			"Note on 33"* ) bind_application 2 ;; # knob press
		    "Note on 90"* ) toggle_mute $col_2_app_pid ;; # top button
			"Note on 88"* ) ;; # bottom button
			"Control change 17"* ) change_volume $col_2_app_pid $data2 ;; # knob turn

			# column 3
			"Note on 34"* ) bind_application 3 ;; # knob press
		    "Note on 40"* ) toggle_mute $col_3_app_pid ;; # top button
			"Note on 91"* ) media_prev ;;
			"Control change 18"* ) change_volume $col_3_app_pid $data2 ;; # knob turn

			# column 4
			"Note on 35"* ) bind_application 4 ;; # knob press
		    "Note on 41"* ) toggle_mute $col_4_app_pid ;; # top button
			"Note on 92"* ) media_next ;;
			"Control change 19"* ) change_volume $col_4_app_pid $data2 ;; # knob turn

			# column 5
			"Note on 36"* ) bind_application 5 ;; # knob press
		    "Note on 42"* ) toggle_mute $col_5_app_pid ;; # top button
			"Note on 86"* ) ;;
			"Control change 20"* ) change_volume $col_5_app_pid $data2 ;; # knob turn

			# column 6
			"Note on 37"* ) bind_application 6 ;; # knob press
		    "Note on 43"* ) toggle_mute $col_6_app_pid ;; # top button
			"Note on 93"* ) media_stop ;;
			"Control change 21"* ) change_volume $col_6_app_pid $data2 ;; # knob turn

			# column 7
			"Note on 38"* ) bind_application 7 ;; # knob press
		    "Note on 44"* ) toggle_mute $col_7_app_pid ;; # top button
			"Note on 94"* ) media_play_pause ;;
			"Control change 22"* ) change_volume $col_7_app_pid $data2 ;; # knob turn

			# column 8
			"Note on 39"* ) bind_application 8 ;; # knob press
		    "Note on 45"* ) toggle_mute $col_8_app_pid ;; # top button
			"Note on 95"* ) ;;
			"Control change 23"* ) change_volume $col_8_app_pid $data2 ;; # knob turn

			# layer a and b buttons
			"Note on 84"* ) assign_profile_1 ;;
			"Note on 85"* ) assign_profile_2 ;;
		esac
	done
}
```
This one took a lot of trial and error, and this function is where we would need to implement profiles for different devices. 
1. We use `aseqdump` to attach to the ALSA output stream of the "X-TOUCH MINI" device (`-p "X-TOUCH-MINI`). 
2. We read each line in a while loop, and set variables according to the format used by the X-Touch Mini in `aseqdump`. 
    - The sequence `$ev1 $ev2 $data1` is used to determine which physical interaction was used. Its values look like "Note on 36" or "Control change 18", which represent Knob 5 Press and Knob 3 Turn, respectively. 
    - For knob turn interactions, we pass the `$data2` value to the change_volume function, otherwise it is discarded.

Note: The difference between Mackie and standard here is the mapping between `$data1` and the physical interaction. E.g. Knob 5 Press in Mackie mode sends "Note on 36", and in standard mode it sends "Control change 13 127". 

## Future Work
This script was amateurish, and today I don't need the functionality it provides. It's unlikely I will continue to work on it, but as an exercise, there are a few layers of improvements I would make:

1. Remove `--machine=joey@.host` from the PulseAudio service up check. 
2. Improve the tragic state of optimization for the change volume functions. We *do not* need to get the entire list of running audio sinks every time we increment or decrement the volume.
3. Eliminate the repetitiveness of the change volume and mute functions.
4. Map interactions to ALSA sequence entries more programmatically (e.g. `"Note on") bind_application $(($data1 - 31)) ;;`) This can apply to both Mackie and standard mode.
5. Modularize functions to make it more portable between input devices. 
6. Rewrite in a proper programming language. Python, or Go, or Rust. 

# Conclusion
This was a fun project. I learned a bit about MIDI and ALSA, a bit about Bash and Systemd, and I built something useful. 

It was [received kindly](https://www.reddit.com/r/linuxaudio/comments/qf59fx/a_little_bash_script_to_control_application/), despite its vast room for improvement. And some folks are [still encountering](https://www.reddit.com/r/linuxaudio/comments/1cr9w68/linux_equivalent_to_pcpanel_or_midi_mixer/) this need, so maybe it's worth revisiting.

Today, I use a [GoXLR Mini](https://www.tc-helicon.com/product.html?modelCode=0803-AAB) with [GoXLR-on-Linux/GoXLR-utility](https://github.com/GoXLR-on-Linux/goxlr-utility/) to get much of the functionality I was wanting. It's missing some things (like dynamically rebinding faders to applications), but has some nice features pamidi could never replicate, such as microphone audio processing. 
