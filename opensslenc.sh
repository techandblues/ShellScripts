#!/bin/bash

tar -cf archive.tar foldername/
openssl enc -aes-256-cbc -salt -in archive.tar -out archive.tar.enc


## Decrypt
## openssl enc -d -aes-256-cbc -in archive.tar.enc -out archive.tar
tar -xf archive.tar

