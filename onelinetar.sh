#!/bin/bash

find . -type f -name "*.txt" -print0 | tar -cf TXTBU.tar --null -T -
