#!/bin/bash 
#dotnet Server.dll
docker build -t Server
docker run -d -p 8080:80 --name streamer Server