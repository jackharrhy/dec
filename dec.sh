#!/usr/bin/env sh
(
  cd ./dectalk || exit
  DISPLAY=:0.0 wine ./say.exe -w "$1.wav" "$2"
  mv "$1.wav" "../out/$1.wav"
)
