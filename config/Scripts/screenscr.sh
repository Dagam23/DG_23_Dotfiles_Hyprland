#!/bin/bash

grim -g "$(slurp)" - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date +%F_%h-%m).png
