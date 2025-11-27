tar -cf - /path/to/your/folder | openssl enc -aes-256-cbc -salt -out ~/Backups/$(basename /path/to/your/folder)_$(date +"%Y%m%d_%H%M%S").tar.enc



