#!/bin/bash

rsync -avz --progress --update ~/Photos/*.tar.zst user@10.0.0.133:/mnt/PhotoBU/

##Cron Entry
##
# 0 2 * * * /usr/bin/rsync -avz --update ~/Photos/*.tar.zst user@10.0.0.133:/mnt/PhotoBU/

