cd ~/Pictures

for d in */; do
    tar -cvf "${d%/}.tar" "$d"
done
