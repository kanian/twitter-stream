#!/bin/bash 
docker build -t twitter-streamer .
docker run --rm -it twitter-streamer --name streamer