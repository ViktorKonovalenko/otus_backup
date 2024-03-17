#!/bin/bash
ip=192.168.56.10
repo_backup=/var/backup/
dir_backup=/etc
borg create --stats --list borg@$ip:$repo_backup::"etc-{now:%Y-%m-%d_%H:%M:%S}" $dir_backup
borg prune --keep-daily 90 --keep-monthly 12 --keep-yearly 1 borg@$ip:$repo_backup
