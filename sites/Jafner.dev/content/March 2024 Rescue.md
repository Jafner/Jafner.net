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

We identify which drives are in the wrong pool by running `sudo zpool status TEMP`, finding each part-uuid in the `/dev/disk/by-partuuid` directory, where it's symlinked to a standard Linux partition name (e.g. `/dev/sda1`). From there, we run `smartctl -a` against the device name and filter to get the serial number. Then we check each serial number against the table in diskshelfmap. I wrote a one-liner.

```sh
for id in $(sudo zpool status TEMP | grep -E "[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}  (ONLINE|DEGRADED)" | tr -s ' ' | cut -d' ' -f 2); do
  echo -n "$id -> ";
  ls -l /dev/disk/by-partuuid |\
  grep $id |\
  cut -d' ' -f 12 |\
  cut -d'/' -f 3 |\
  sed 's/^/\/dev\//' |\
  xargs sudo smartctl -a |\
  grep Serial |\
  tr -s ' ' |\
  cut -d' ' -f 3
done
```

```sh
for id in $(sudo zpool status TEMP | grep -E "[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}  (ONLINE|DEGRADED)" | tr -s ' ' | cut -d' ' -f 2); do echo -n "$id -> "; ls -l /dev/disk/by-partuuid | grep $id | cut -d' ' -f 12 | cut -d'/' -f 3 | sed 's/^/\/dev\//' | xargs sudo smartctl -a | grep Serial | tr -s ' ' | cut -d' ' -f 3; done
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

|     |    X1    |    X2    |    X3    |    X4    |
| :-: | :------: | :------: | :------: | :------: |
| Y1  | VJGPS30X | VK0ZD6ZY | VJG282NX | VJG2PVRX |
| Y2  | VJGR6TNX | 2EG14YNJ | VJGJVTZX | VJG1H9UX |
| Y3  | VJGJUWNX | 2EGXD27V | VJGJAS1X | VJG2UTUX |
| Y4  | VJGRGD2X | 2EGL8AVV | 2EKA903X | VJGRRG9X |
| Y5  | VJGK56KX | 2EGNPVWV | 2EKATR2X | VKH3Y3XX |
| Y6  | VLKV9N8V | R5G4W2VV | VLKXPS1V | VKGW5YGX |

So our matches are:

- Serial: `VJG282NX`, partuuid: `0fabfe6b-5305-4711-921c-926110df24b7`, shelf coordinates: Y1/X3

Hmm. That's it? Something's unaccounted for. Also one of those drives is weird. Let's check the full `smartctl` output for that drive.

`id=dd453900-d8c0-430d-bc1f-c022e62417ae; ls -l /dev/disk/by-partuuid | grep $id | cut-d' ' -f 11 | xargs basename | sed 's/^/\/dev\//' | xargs sudo smartctl -a` returns a normal-looking output.
Except the serial is a little weird.

```
Serial number:        001703PXPS1V        VLKXPS1V
```

Huh. Interesting. That maps to our Y6/X3 serial. I wonder how that happened.

So our _actual_ matches are:

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
We recreate our datasets with default settings and begin the copy back from `TEMP` to `Media`. We'll use a slightly more sophisticated strategy for copying back. We run the `copy.sh` script from a remote SSH session with nohup.

`ssh admin@192.168.1.10 nohup ~/copy.sh /mnt/TEMP/Media/ /mnt/Media/Media/`

And we wait. Painfully. We can check in occasionally with `tail -f ~/copy.tmp`, and we should get an email notification when the command completes.

Compare disk usage and file count between directories:

```
CHECKPATH="Sub/Directory";
echo "Source: /mnt/TEMP/$CHECKPATH";
    echo -n "    Disk usage: " && sudo du -s /mnt/TEMP/$CHECKPATH;
    echo -n "    File count: " && sudo find /mnt/TEMP/$CHECKPATH -type f | wc -l;
echo "Dest: /mnt/Media/$CHECKPATH";
    echo -n "    Disk usage: " && sudo du -s /mnt/Media/$CHECKPATH;
    echo -n "    File count: " && sudo find /mnt/Media/$CHECKPATH -type f | wc -l
```

Final output of `sudo zpool status Media TEMP`

```
  pool: Media
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
        Sufficient replicas exist for the pool to continue functioning in a
        degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
        repaired.
  scan: resilvered 9.19M in 00:00:03 with 0 errors on Sun Mar  3 10:30:11 2024
config:

        NAME                                      STATE     READ WRITE CKSUM
        Media                                     DEGRADED     0     0     0
          raidz2-0                                DEGRADED     0     0     0
            a9df1c82-cc15-4971-8080-42056e6213dd  ONLINE       0     0     0
            8398ae95-9119-4dd6-ab3a-5c0af82f82f4  ONLINE       0     0     0
            44ae3ae0-e8f9-4dbc-95ba-e64f63ab7460  ONLINE       0     0     0
            eda6547f-9f25-4904-a5bd-8f8b4e36d859  ONLINE       0     0     0
            05241f52-542c-4c8c-8f20-d34d2878c41a  ONLINE       0     0     0
            38cd7315-e269-4acc-a05b-e81362a9ea39  ONLINE       0     0     0
            d50abb30-81fd-49c6-b22e-43fcee2022fe  FAULTED     23     0     0  too many errors
            90be0e9e-7af1-4930-9437-c36c24ea81c5  ONLINE       0     0     0
            29b36c4c-8ad2-4dcb-9b56-08f5458817d2  ONLINE       0     0     0
            d59a8281-618d-4bab-bd22-9f9f377baacf  ONLINE       0     0     0
            e0431a50-b5c6-459e-85bd-d648ec2c21d6  ONLINE       0     0     0
            cd4808a8-a137-4121-a5ff-4181faadee64  ONLINE       0     0     0

errors: No known data errors

  pool: TEMP
 state: DEGRADED
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 3.17M in 14:29:34 with 4 errors on Sun Mar  3 14:29:35 2024
config:

        NAME                                      STATE     READ WRITE CKSUM
        TEMP                                      DEGRADED     0     0     0
          raidz2-0                                DEGRADED  945K     0     0
            dad98d96-3cbe-469e-b262-b8416dfc72ec  ONLINE       0     0     0
            0fabfe6b-5305-4711-921c-926110df24b7  OFFLINE      0     0     0
            864e8c2d-0925-4018-b440-81807d3c5c9a  ONLINE      11     0     0
            d7b9a2ec-5f26-4649-a7fb-cb1ae953825e  ONLINE       0     0     0
            dd453900-d8c0-430d-bc1f-c022e62417ae  OFFLINE      0     0     0
            507666cd-91e2-4960-af02-b15899a22487  ONLINE       0     0     0
            5eaf90b6-0ad1-4ec0-a232-d704c93dae9a  ONLINE       0     0     0
            cf9cc737-a704-4bea-bcee-db2cfe4490b7  ONLINE       0     0     0
            50cc36be-001d-4e00-a0ca-e4b557bd6852  DEGRADED  366K     0     2  too many errors
            142d45e8-4f30-4492-b01f-f22cba129fee  DEGRADED  596K     0     6  too many errors
```

And we get the serials of each of our drives so as to ensure the degraded drives don't get pulled back into the pool:

```sh
for id in $(sudo zpool status TEMP | grep -E "[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}  (ONLINE|DEGRADED|FAULTED)" | tr -s ' ' | cut -d' ' -f 2); do
  echo -n "$id -> ";
  ls -l /dev/disk/by-partuuid |\
  grep $id |\
  tr -s ' ' |\
  cut -d' ' -f 11 |\
  cut -d'/' -f 3 |\
  sed 's/^/\/dev\//' |\
  xargs sudo smartctl -a |\
  grep Serial |\
  tr -s ' ' |\
  cut -d' ' -f 3
done
```

Which gives us:

```
dad98d96-3cbe-469e-b262-b8416dfc72ec -> 2EKA92XX
864e8c2d-0925-4018-b440-81807d3c5c9a -> VJG2T4YX
d7b9a2ec-5f26-4649-a7fb-cb1ae953825e -> VKH3XR2X
507666cd-91e2-4960-af02-b15899a22487 -> VJG1NP9X
5eaf90b6-0ad1-4ec0-a232-d704c93dae9a -> VKH40L6X
cf9cc737-a704-4bea-bcee-db2cfe4490b7 -> VJG2808X
50cc36be-001d-4e00-a0ca-e4b557bd6852 -> VKHNH0GX # Degraded
142d45e8-4f30-4492-b01f-f22cba129fee -> VKJWPAEX # Degraded
```

Then we hit the big red button again: `Storage -> TEMP -> Export/Disconnect`

- [x] Destroy data on this pool?
- [x] Delete configuration of shares that used this pool?
- [x] Confirm Export/Disconnect?

Cry a little bit, then hit the final Export/Disconnect button.

And we'll also grab the partuuid-to-serial mappings for the Media pool:

```
a9df1c82-cc15-4971-8080-42056e6213dd -> VJGJVTZX
8398ae95-9119-4dd6-ab3a-5c0af82f82f4 -> VKGW5YGX
44ae3ae0-e8f9-4dbc-95ba-e64f63ab7460 -> VJG282NX
eda6547f-9f25-4904-a5bd-8f8b4e36d859 -> 2EKA903X
05241f52-542c-4c8c-8f20-d34d2878c41a -> VJGRRG9X
38cd7315-e269-4acc-a05b-e81362a9ea39 -> VKH3Y3XX
90be0e9e-7af1-4930-9437-c36c24ea81c5 -> VJGR6TNX
29b36c4c-8ad2-4dcb-9b56-08f5458817d2 -> VJGJAS1X
d59a8281-618d-4bab-bd22-9f9f377baacf -> 2EKATR2X
e0431a50-b5c6-459e-85bd-d648ec2c21d6 -> VJGK56KX
cd4808a8-a137-4121-a5ff-4181faadee64 -> VJGJUWNX
```

We shutdown the server, then the NAS.

After shutting down the NAS, I realize that I am stupid. My one-liner to convert partuuid to serial only grabs devices with the ONLINE or DEGRADED status, not FAULTED. Whatever. We can fix that later.

Next, we're going to formalize a few of the datasets we had in the Media pool:

- `Media/Media/3D Printing` -> `Media/3DPrinting`
- `Media/Media/Audio` -> `Media/Audio`
- `Media/Media/Images` -> `Media/Images`
- `Media/Media/Text` -> `Media/Text`
- `Media/Media/Video` -> `Media/Video`

We're basically pulling every type of Media up one directory.

### Configuring ACLs for New Datasets

Our hosts are configured to connect as the user `smbuser` with the group `smbuser`.
So when we create a Unix ACL for a new dataset, we configure as follows:

1. Owner -> User: `smbuser` with box checked for Apply User
2. Owner -> Group: `smbuser` with box checked for Apply Group
3. Check box for Apply permissions recursively. (Confirm and continue).
4. Leave access mode matrix as default (755).
5. Save.

### Riding the Update Train

_choo choo_

It's been a while since I updated TrueNAS. This install was created a bit before TrueNAS existed, and updated once from FreeNAS (BSD) to TrueNAS Scale (Linux).

Our installed version is TrueNAS-22.12.3. Latest stable is 23.10.2. Latest beta is 24.04.

According to the [upgrade paths](https://www.truenas.com/docs/truenasupgrades/#upgrade-paths) page, our upgrade path should go:

1. To `22.12.4.2`, the final patch of 22.12.
2. To `23.10.1.3`, the latest stable version of the Cobria update train.

From there, we have the choice to upgrade to the Dragonfish nightly build ([release notes](https://www.truenas.com/docs/scale/gettingstarted/scalereleasenotes/)).

### Setting up Rsync Backups

In order to connect to our backup NAS, we use the following parameters when configuring our Rsync tasks (we'll use the `HomeVideos` dataset for example):

- Path: `/mnt/Media/HomeVideos/` We use the trailing slash. I'm not sure why, but that's how it was, and so it shall stay.
- Rsync Mode: `SSH`
- Connect using: `SSH private key stored in user's home directory` We have an SSH private key in the home directory of the `root` user.
- Remote Host: `admin@192.168.1.11`
- Remote SSH Port: `22`
- Remote Path: `/mnt/Backup/Backup/Media/Media/Video/HomeVideos` We have the data organized by the old dataset layout. Some day I'll fix that. Surely...
- User: `root`
- Direction: `Push`
- Description: `Backup: HomeVideos`
- Schedule: `Daily (0 0 * * *) At 00:00 (12:00 AM)`
- Recursive: `[X]`
- Enabled: `[X]`
- Times: `[X]`
- Compress: `[X]`
- Archive: `[X]`
- Delete: `[X]`
- Delay Updates: `[X]`

### Reorganizing our Media shares

In moving our datasets,

- `/mnt/Media/Media/Video/Movies` to `/mnt/Media/Movies`,
- `/mnt/Media/Media/Video/Shows` to `/mnt/Media/Shows`, and
- `/mnt/Media/Media/Audio/Music` to `/mnt/Media/Music`

We will need to reorganize some stuff, and reconfigure anything dependent on those datasets. This includes:

- SMB shares (`Media` will need to be replaced with `Movies` and `Shows`)
- Snapshot tasks will need to be created for the datasets
- SMB client reconfiguration. Any hosts connecting to the old `Media` share is expecting a certain directory structure below it. We'll need to cope with that.

Below I document all uses of the `/mnt/nas/media` directory in absolute host:container mappings:

- Autopirate:
  - Radarr: `/mnt/nas/media/Video/Movies:/movies`
  - Sonarr: `/mnt/nas/media/Video/Shows:/shows`
  - Bazarr: `/mnt/nas/media/Video/Movies:/movies`, `/mnt/nas/media/Video/Shows:/tv`
  - Sabnzbd: `/mnt/nas/media/Video/Movies:/movies`, `/mnt/nas/media/Video/Shows:/shows`, `/mnt/nas/media/Audio/Music:/music`
  - Tdarr: `/mnt/nas/media/Video/Movies:/movies`, `/mnt/nas/media/Video/Shows:/shows`
  - Tdarr-node: `/mnt/nas/media/Video/Movies:/movies`, `/mnt/nas/media/Video/Shows:/shows`
- Jellyfin:
  - Jellyfin: `/mnt/nas/media/Video/Movies:/data/movies`, `/mnt/nas/media/Video/Shows:/data/tvshows`
- Plex:
  - Plex: `/mnt/nas/media/Video/Movies:/movies`, `/mnt/nas/media/Video/Shows:/shows`, `/mnt/nas/media/Audio/Music:/music`

We're gonna have to refactor all of these.
Most use `MEDIA_DIR=/mnt/nas/media` in their `.env` file as the baseline.
We'll need to replace that with `MOVIES_DIR=/mnt/nas/movies` and `SHOWS_DIR=/mnt/nas/shows`. Also `MUSIC_DIR=/mnt/nas/music` I guess.
Then we'll need to find the lines in each compose file which look like `${MEDIA_DIR}/Video/Movies` and `${MEDIA_DIR}/Video/Shows` and replace them with `${MOVIES_DIR}` and `${SHOWS_DIR}` respectively.
Also `${MEDIA_DIR}/Audio/Music` to `${MUSIC_DIR}`.
None of the container-side mappings should need to be changed.

### Replacing Yet Another Disk

The drive hosting part-uuid `d50abb30-81fd-49c6-b22e-43fcee2022fe` failed 7 SMART short tests in a row while we were moving our data around. Great.

So we get the disk ID from the part uuid (we already knew it was `/dev/sdx` because of the email notifications I was getting spammed with during the move, but let's follow the exercise) with `ls -l /dev/disk/by-partuuid | grep d50abb30-81fd-49c6-b22e-43fcee2022fe`, which informed us that the partition label was `../../sdx2`. So we open the web UI, navigate to the Manage Disks panel of the Media pool, find our bad drive, make note of the serial number, and hit Offline. Once that's done, we check diskshelfmap to see where that drive was located. We physically remove the caddy from the shelf, then the drive from the caddy. Throw the new drive in, and note its serial number and document the swap in diskshelfmap. We wait a bit for the drive to be recognized. We run a quick sanity check on the new drive to make sure its SMART info looks good and the serial number matches `smartctl -a /dev/sdx`, then we kick off the replacement and resilver with `zpool replace Media d50abb30-81fd-49c6-b22e-43fcee2022fe /dev/sdx`.

Now we wait like 2 days for the resilver to finish and we hope no other drives fail in the meantime.
