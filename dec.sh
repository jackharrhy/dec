#!/usr/bin/env sh
(
  cd ./dectalk || exit
  wine ./say.exe -w "$1.wav" "$2"
  mv "$1.wav" "../out/$1.wav"
)
