#!/bin/bash

cd /home/gitlab-runner/thelatest-deploy

date=$(date +'%d/%m/%Y %H:%M:%S')
logfile="/var/log/check-ttrss.log"

url="https://thelatest.com/main/justin"
content=`wget -q -O - $url`
timestamp=`echo $content | perl -pe 's/.*?<\/i>&nbsp;(.*?)<\/span>.*/$1/'`

if [[ "$timestamp" == *"hour"* ]]; then
    echo "$date - No recent stories, restarting ttrss container..." >> "$logfile"
    # docker container needs a restart
    docker start thelatest-deploy_ttrss-updater_1
    # let everyone know about the system status
    curl --ssl-reqd \
    --url 'smtps://developersinuk.com:465' \
    --user 'alert@developersinuk.com:Nt%6cv32' \
    --mail-from 'alert@developersinuk.com' \
    --mail-rcpt 'jeffhall@thelatest.com' \
    --upload-file /opt/mail.txt
fi
