cd ~/Pictures

for d in */; do
    tar -rvf "${d%/}.tar" "$d"
done
