## Hardware Reports with `inxi`
`inxi` is a script which employs a wide array of system information utilities to assemble a holistic system summary. Check out [the repository](https://github.com/smxi/inxi) for more information.

### Install `inxi`
`curl -o inxi https://raw.githubusercontent.com/smxi/inxi/master/inxi && chmod +x inxi` to download and make executable the dependency-free script.

### Gather Host Info
`sudo ./inxi -CDGmMNPS` to generate information summary. Refer to [`man inxi`](http://manpages.ubuntu.com/manpages/bionic/man1/inxi.1.html) for more information.

* `-C` Full CPU info
* `-D` Full disk info
* `-G` GPU info
* `-m` Memory (RAM) info
* `-M` Machine info
* `-N` Network card info
* `-P` Partition info
* `-S` System info (hostname, kernel, DE, WM, distro, etc.)