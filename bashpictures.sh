cd ~/Pictures
sudo bash -c 'for d in */; do tar -cvf "${d%/}.tar" "$d"; done'
