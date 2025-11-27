#!/bin/bash

# Make a folder called content
# This will host html files and map to nginx:/usr/share/nginx/html
# Read Only
# Will run as a daemon
# Create a folder for all related files
# Map to local 8080 the nginx expected port 80
# Use a volume for consistency and ease of files being updated
# Name the Website
# Look for an SSL certificate in the future

docker -run --name contentvia -p 8080:80 -v ./content:/usr/share/nginx/html:ro -d nginx
