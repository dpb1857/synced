#!/bin/bash

dir=/sys/class/backlight/intel_backlight

brightness=$(cat $dir/brightness)
new=$(( $brightness * (100 + $1) / 100))
echo $new > $dir/brightness
