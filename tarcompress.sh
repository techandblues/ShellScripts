cd ~/Photos
for d in */ ; do
    tar --zstd -cf "${d%/}.tar.zst" "$d"
done

