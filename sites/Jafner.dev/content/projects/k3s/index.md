+++
title = 'K3s'
description = " "
date = 2024-08-06T13:08:14-07:00
aliases = []
author = "Joey Hafner"
ogimage = '/img/Jafner.dev.logo.png'
slug = "draft"
draft = true
+++

- Bard, Cleric, and Ranger are Dell Wyse 5070s onto which I installed Debian 12.
- They have the IPs `192.168.1.{31..33}`
- On the first one, I ran `curl -sfL https://get.k3s.io | K3S_TOKEN=<my-token> sh -s - server --cluster-init`, and then on each of the other two I ran `curl -sfL https://get.k3s.io | K3S_TOKEN=<my-token> sh -s - server --server https://192.168.1.31:6443`

1. `kubectl apply -f dashboard.deployment.yml`
2. `kubectl create -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml`
3. `kubectl -n kubernetes-dashboard create token admin-user`
4. `kubectl proxy`

