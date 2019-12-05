#!/usr/bin/env sh
cd ./dectalk && wine say.exe -w "../out/$1.wav" "$2" && cd ..
