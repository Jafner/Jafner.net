# Steps Taken

We hooked up 8 "spare" drives as a janky temporary pool. They're literally stacked 4-high on top of the chassis. It's awful. We created a RAID-Z2 pool called `TEMP` with these drives. We then copied all data off the `Media` pool with `sudo rsync -avhW /mnt/Media/Media/ /mnt/TEMP/Media/`. It was interrupted once when the PC running the SSH session experienced a crash to black. We reconnected the session and ran the same command. It resumed just fine. The copy completed in around 48 hours with interruptions accounted for. Reported copy speed was 285MB/s.

Next we destroy the `Media` pool. [TrueNAS docs](https://www.truenas.com/docs/scale/scaletutorials/storage/managepoolsscale/#exporting/disconnecting-or-deleting-a-pool). We open the Storage Dashboard and click "Export/Disconnect" for the `Media` pool. Before confirming, we take note of the services that will be disrupted by the deletion (to be recreated later):

```
These services depend on pool Media and will be disrupted if the pool is detached:
    SMB Share:
        Media
        AV 
    Snapshot Task:
        Media/AV
        Media/Media 
    Rsync Task:
        /mnt/Media/Media/Video/HomeVideos
        /mnt/Media/Media/Images/
        /mnt/Media/Media/Video/Recordings/ 
```

We check all three boxes for destroying the data, deleting the share configurations, and to confirm the export/disconnect. Type the pool name into the confirm box, and hit the big red button. 

At this point my exhaustion 48 hours ago bit me in the ass. When I created the TEMP pool, I thoughtlessly added the two drives which had been removed from Media to create a 10-wide RAID-Z2. Okay, so we've got a rough situation on our hands. I see two possibilities:

1. Offline the two misplaced drives from TEMP, create a 12-wide Media pool, and begin the copy. Life is for the living. 
2. Just order a couple more drives on Ebay, replace the two misplaced drives, resilver, and continue as planned. 

I carefully calculated that the number of times you live is once, so we're flying by the seat of our pants. 

We identify which drives are in the wrong pool by running `sudo zpool status TEMP`, finding each part-uuid in the `/dev/disk/by-partuuid` directory, where it's symlinked to a standard Linux partition name (e.g. `/dev/sda1`). From there, we run `smartctl -a` against the device name and filter to get the serial number. Then we check each serial number against the table in [diskshelfmap](DISKSHELFMAP.md). I wrote a one-liner.

```sh
for id in $(sudo zpool status TEMP | grep -E "[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}" | tr -s ' ' | cut -d' ' -f 2); do 
    echo -n "$id -> "
    ls -l /dev/disk/by-partuuid |\
    grep $id |\
    cut -d' ' -f 11 |\
    xargs basename |\
    sed 's/^/\/dev\//' |\
    xargs sudo smartctl -a |\
    grep Serial |\
    tr -s ' ' |\
    cut -d' ' -f 3
done
```

Output:
```
dad98d96-3cbe-469e-b262-b8416dfc72ec -> 2EKA92XX
0fabfe6b-5305-4711-921c-926110df24b7 -> VJG282NX
864e8c2d-0925-4018-b440-81807d3c5c9a -> VJG2T4YX
d7b9a2ec-5f26-4649-a7fb-cb1ae953825e -> VKH3XR2X
dd453900-d8c0-430d-bc1f-c022e62417ae -> 001703PXPS1V
507666cd-91e2-4960-af02-b15899a22487 -> VJG1NP9X
5eaf90b6-0ad1-4ec0-a232-d704c93dae9a -> VKH40L6X
cf9cc737-a704-4bea-bcee-db2cfe4490b7 -> VJG2808X
50cc36be-001d-4e00-a0ca-e4b557bd6852 -> VKHNH0GX
142d45e8-4f30-4492-b01f-f22cba129fee -> VKJWPAEX
```

At time of error, our disk shelf map looks like:

|    | X1        | X2       | X3       | X4       |
|:--:|:---------:|:--------:|:--------:|:--------:|
| Y1 | VJGPS30X  | VK0ZD6ZY | VJG282NX | VJG2PVRX |
| Y2 | VJGR6TNX  | 2EG14YNJ | VJGJVTZX | VJG1H9UX |
| Y3 | VJGJUWNX  | 2EGXD27V | VJGJAS1X | VJG2UTUX |
| Y4 | VJGRGD2X  | 2EGL8AVV | 2EKA903X | VJGRRG9X |
| Y5 | VJGK56KX  | 2EGNPVWV | 2EKATR2X | VKH3Y3XX |
| Y6 | VLKV9N8V  | R5G4W2VV | VLKXPS1V | VKGW5YGX |

So our matches are:

- Serial: `VJG282NX`, partuuid: `0fabfe6b-5305-4711-921c-926110df24b7`, shelf coordinates: Y1/X3

Hmm. That's it? Something's unaccounted for. Also one of those drives is weird. Let's check the full `smartctl` output for that drive. 

`id=dd453900-d8c0-430d-bc1f-c022e62417ae; ls -l /dev/disk/by-partuuid | grep $id | cut-d' ' -f 11 | xargs basename | sed 's/^/\/dev\//' | xargs sudo smartctl -a` returns a normal-looking output. 
Except the serial is a little weird.
```
Serial number:        001703PXPS1V        VLKXPS1V
```

Huh. Interesting. That maps to our Y6/X3 serial. I wonder how that happened. 

So our *actual* matches are:

- Serial: `VJG282NX`, partuuid: `0fabfe6b-5305-4711-921c-926110df24b7`, shelf coordinates: Y1/X3
- Serial: `VLKXPS1V`, partuuid: `dd453900-d8c0-430d-bc1f-c022e62417ae`, shelf coordinates: Y6/X3

So we have our two misplaced drives. Just as a sanity check, we'll physically remove each drive (one at a time) and make sure the correct devices are disappearing from the pool. 
We remove the drive at Y1/X3, then run `zpool status TEMP` and we see `0fabfe6b-5305-4711-921c-926110df24b7  REMOVED`. That matches. Cool. Plug it back in and wait for it to go back to ONLINE status.
Next we remove the drive at Y6/X3. Same test, `zpool status TEMP` which contains `dd453900-d8c0-430d-bc1f-c022e62417ae  REMOVED`. Dope. All looking good. Plug it back in and wait for return to normal.

We wait a few seconds for the drive to come back online. We check `zpool status TEMP` and we see something we weren't expecting:

```
  pool: TEMP
 state: ONLINE
status: One or more devices is currently being resilvered.  The pool will
        continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Fri Mar  1 22:47:28 2024
        0B scanned at 0B/s, 0B issued at 0B/s, 58.1T total
        0B resilvered, 0.00% done, no estimated completion time
config:

        NAME                                      STATE     READ WRITE CKSUM
        TEMP                                      ONLINE       0     0     0
          raidz2-0                                ONLINE       0     0     0
            dad98d96-3cbe-469e-b262-b8416dfc72ec  ONLINE       0     0     0
            0fabfe6b-5305-4711-921c-926110df24b7  ONLINE       0     0     0
            864e8c2d-0925-4018-b440-81807d3c5c9a  ONLINE       0     0     0
            d7b9a2ec-5f26-4649-a7fb-cb1ae953825e  ONLINE       0     0     0
            dd453900-d8c0-430d-bc1f-c022e62417ae  ONLINE       0     0     0  (awaiting resilver)
            507666cd-91e2-4960-af02-b15899a22487  ONLINE       0     0     0
            5eaf90b6-0ad1-4ec0-a232-d704c93dae9a  ONLINE       0     0     0
            cf9cc737-a704-4bea-bcee-db2cfe4490b7  ONLINE       0     0     0
            50cc36be-001d-4e00-a0ca-e4b557bd6852  ONLINE       0     0     0
            142d45e8-4f30-4492-b01f-f22cba129fee  ONLINE       0     0     0

errors: No known data errors
```

It gets weirder though. A few minutes pass and we get `zpool status TEMP`:

```
  pool: TEMP
 state: ONLINE
status: One or more devices is currently being resilvered.  The pool will
        continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Fri Mar  1 22:51:23 2024
        0B scanned at 0B/s, 0B issued at 0B/s, 58.1T total
        0B resilvered, 0.00% done, no estimated completion time
config:

        NAME                                      STATE     READ WRITE CKSUM
        TEMP                                      ONLINE       0     0     0
          raidz2-0                                ONLINE       0     0     0
            dad98d96-3cbe-469e-b262-b8416dfc72ec  ONLINE       0     0     0
            0fabfe6b-5305-4711-921c-926110df24b7  ONLINE       0     0     0
            864e8c2d-0925-4018-b440-81807d3c5c9a  ONLINE       0     0     0
            d7b9a2ec-5f26-4649-a7fb-cb1ae953825e  ONLINE       0     0     0
            dd453900-d8c0-430d-bc1f-c022e62417ae  ONLINE       0     0     0
            507666cd-91e2-4960-af02-b15899a22487  ONLINE       0     0     0
            5eaf90b6-0ad1-4ec0-a232-d704c93dae9a  ONLINE       0     0     0
            cf9cc737-a704-4bea-bcee-db2cfe4490b7  ONLINE       0     0     0
            50cc36be-001d-4e00-a0ca-e4b557bd6852  ONLINE       0     0     0
            142d45e8-4f30-4492-b01f-f22cba129fee  ONLINE       0     0     0

errors: No known data errors
```

No drives awaiting resilver. But the resilver claims to be in progress with zero bytes scanned. 
A quick `zpool clear TEMP` doesn't change anything. Same with `zpool resilver TEMP`. We'll give a reboot a shot. 

Huh, alright. 

```
  pool: TEMP
 state: ONLINE
  scan: resilvered 1.18M in 00:07:53 with 0 errors on Fri Mar  1 22:59:16 2024
config:

        NAME                                      STATE     READ WRITE CKSUM
        TEMP                                      ONLINE       0     0     0
          raidz2-0                                ONLINE       0     0     0
            dad98d96-3cbe-469e-b262-b8416dfc72ec  ONLINE       0     0     0
            0fabfe6b-5305-4711-921c-926110df24b7  ONLINE       0     0     0
            864e8c2d-0925-4018-b440-81807d3c5c9a  ONLINE       0     0     0
            d7b9a2ec-5f26-4649-a7fb-cb1ae953825e  ONLINE       0     0     0
            dd453900-d8c0-430d-bc1f-c022e62417ae  ONLINE       0     0     0
            507666cd-91e2-4960-af02-b15899a22487  ONLINE       0     0     0
            5eaf90b6-0ad1-4ec0-a232-d704c93dae9a  ONLINE       0     0     0
            cf9cc737-a704-4bea-bcee-db2cfe4490b7  ONLINE       0     0     0
            50cc36be-001d-4e00-a0ca-e4b557bd6852  ONLINE       0     0     0
            142d45e8-4f30-4492-b01f-f22cba129fee  ONLINE       0     0     0

errors: No known data errors
```

Okay, now we need to offline those two drives to make them available to use in the new Media pool.
We could follow the [TrueNAS docs](https://www.truenas.com/docs/core/coretutorials/storage/disks/diskreplace/#taking-a-failed-disk-offline) web UI instructions, but I prefer the CLI. So instead we'll reference [Oracle's docs](https://docs.oracle.com/cd/E19253-01/819-5461/gazgm/index.html). So we have two commands to run:

- `zpool offline TEMP 0fabfe6b-5305-4711-921c-926110df24b7`
- `zpool offline TEMP dd453900-d8c0-430d-bc1f-c022e62417ae`

And as expected we're now in a degraded state.

```
  pool: TEMP
 state: DEGRADED
status: One or more devices has been taken offline by the administrator.
        Sufficient replicas exist for the pool to continue functioning in a
        degraded state.
action: Online the device using 'zpool online' or replace the device with
        'zpool replace'.
  scan: resilvered 1.18M in 00:07:53 with 0 errors on Fri Mar  1 22:59:16 2024
config:

        NAME                                      STATE     READ WRITE CKSUM
        TEMP                                      DEGRADED     0     0     0
          raidz2-0                                DEGRADED     0     0     0
            dad98d96-3cbe-469e-b262-b8416dfc72ec  ONLINE       0     0     0
            0fabfe6b-5305-4711-921c-926110df24b7  OFFLINE      0     0     0
            864e8c2d-0925-4018-b440-81807d3c5c9a  ONLINE       0     0     0
            d7b9a2ec-5f26-4649-a7fb-cb1ae953825e  ONLINE       0     0     0
            dd453900-d8c0-430d-bc1f-c022e62417ae  OFFLINE      0     0     0
            507666cd-91e2-4960-af02-b15899a22487  ONLINE       0     0     0
            5eaf90b6-0ad1-4ec0-a232-d704c93dae9a  ONLINE       0     0     0
            cf9cc737-a704-4bea-bcee-db2cfe4490b7  ONLINE       0     0     0
            50cc36be-001d-4e00-a0ca-e4b557bd6852  ONLINE       0     0     0
            142d45e8-4f30-4492-b01f-f22cba129fee  ONLINE       0     0     0

errors: No known data errors
```

Now if I did my homework properly, we should be able to build a new pool which contains the offlined drives. And sure enough the web UI corroborates. 
We navigate to the Storage page, then click "Create Pool". We add all available drives (`sdd sdf sdh sdj sdl sdp sdq sdr sdt sdu sdx sdy`) to a data vdev in a RAID-Z2 configuration. We name the pool `Media`. 
And we hit Create, check the confirm box, and click Create Pool. It only takes a few seconds and we're back in business. Our new pool has one disk failing SMART tests, but we're going to tolerate that for now.
We recreate our datasets with default settings and begin the copy back from `TEMP` to `Media`. We'll use a slightly more sophisticated strategy for copying back. We run the [`copy.sh` ](./copy.sh) script from a remote SSH session with nohup. 

`ssh admin@192.168.1.10 nohup ~/copy.sh /mnt/TEMP/Media/ /mnt/Media/Media/`

And we wait. Painfully. We can check in occasionally with `tail -f ~/copy.tmp`, and we should get an email notification when the command completes. 

