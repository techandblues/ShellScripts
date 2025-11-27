#!/bin/bash

 tar -cvf HTML.tar *.html | openssl enc -aes-256-cbc -salt -in HTML.tar  -out HTML.tar.enc

