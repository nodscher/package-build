#!/bin/bash
set -e

[ -f log/cron ] || touch log/cron || (sudo chown -R user:user log && touch log/cron) || exit 1

sudo crond

tail -f log/cron
