#!/bin/bash
cd /home/joey/docker_config/
git add --all
git commit -am "$(date)"
git push
