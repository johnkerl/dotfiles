#!/bin/bash

# Black
# Blue
# Brown
# Cyan
# DarkBlue
# DarkCyan
# DarkGray
# DarkGreen
# DarkGrey
# DarkMagenta
# DarkRed
# DarkYellow
# Gray
# Green
# Grey
# LightBlue
# LightCyan
# LightGray
# LightGreen
# LightGrey
# LightMagenta
# LightRed
# LightYellow
# Magenta
# Red
# White
# Yellow

colors="
  Black \
  Blue \
  Brown \
  Cyan \
  DarkBlue \
  DarkCyan \
  DarkGray \
  DarkGreen \
  DarkGrey \
  DarkMagenta \
  DarkRed \
  DarkYellow \
  Gray \
  Green \
  Grey \
  LightBlue \
  LightCyan \
  LightGray \
  LightGreen \
  LightGrey \
  LightMagenta \
  LightRed \
  LightYellow \
  Magenta \
  Red \
  White \
  Yellow"

for x in $colors; do
  echo "syntax match HL_$x /^.*$x\$/"
done
echo
for x in $colors; do
  echo "highlight HL_$x ctermfg=$x"
done
