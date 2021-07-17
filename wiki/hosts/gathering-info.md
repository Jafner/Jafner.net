---
title: Gathering System Information
description: Documentation for gathering system information for use in host configuration pages
published: true
date: 2021-07-17T04:50:28.573Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:48:21.645Z
---

# The `inxi` Script
`inxi` is a script which employs a wide array of system information utilities to assemble a holistic system summary. Check out [the repository](https://github.com/smxi/inxi) for more information.

## Using `inxi`
1. `curl -o inxi  https://raw.githubusercontent.com/smxi/inxi/master/inxi && chmod +x inxi`
to download the script and make it executable.
2. `sudo ./inxi -CDGImMNPS -W 98405`
to generate timestamped system information summary. Refer to [`man inxi`](http://manpages.ubuntu.com/manpages/bionic/man1/inxi.1.html) for more information.
3. Copy the output to the host's config page.