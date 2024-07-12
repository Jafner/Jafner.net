## TrueNAS Data Safety

### Scheduled Jobs

- Daily snapshot of all datasets at midnight.
- Daily short SMART test of all disks at 11:00 PM.
- Daily ZFS replication for all configured datasets at 01:00 AM
- Weekly rsync push tasks for all configured datasets at 01:00 AM on Sunday. 
- Weekly check for scrub age threshold at 03:00 AM on Sunday. Will only run scrub if previous scrub was more than 35 days ago. 

### Scrub Tasks
- boot-pool: `every 7 days`. 
- Media: `0 3 * * 7`, "At 03:00 on Sunday." Threshold Days: 34.
- Tank: `0 0 * * 7`, "At 03:00 on Sunday." Threshold Days: 34.

This will cause our pools to be scrubbed once per ~5 weeks, and only ever at 3 AM on a Sunday. Scrubbing our pools is a read-intensive operation for all disks in the pool, so we prefer not to induce undue stress. 

> Note: Why is the boot pool different?
> TrueNAS Scale treats the boot pool significantly differently from data pools. Rather than being configured under the Data Protection -> Scrub Tasks, scrub rules for the boot pool are much more limited, and they are configured under Boot -> Stats/Settings.

### Snapshotting
Each dataset is configured with a Periodic Snapshot Task with the following parameters:
 - Snapshot Lifetime: 2 WEEK
 - Naming Scheme: `auto-%Y-%m-%d_%H-%M`
 - Schedule: Daily (0 0 * * *) At 00:00 (12:00AM)
 - Recursive: False.
 - Allow taking empty snapshots: True.
 - Enabled: True.

### Rsync Tasks
> Note: Deprecated.
> These tasks have been disabled as we've moved to ZFS replication. 

A subset of our datasets are configured to Rsync to Monk, our backup server. 
- Media/HomeVideos
- Media/Recordings
- Media/Images
- Tank/Text
- Tank/Archive
- Tank/AppData

> Note: Why not ZFS replication?
> Legacy. Started out with Rsync and migrating would be a significant challenge. Would like to migrate at some point. 

Each of our Rsync tasks is configured with the following parameters:

#### Source
- Path: `/mnt/Path/To/Dataset/` **Trailing `/` is critical.**
- User: `admin`
- Direction: Push
- Description: 

#### Remote
- Rsync Mode: `SSH`
- Connect using `SSH private key stored in user's home directory`
- Remote Host: `admin@192.168.1.11`
- Remote SSH Port: `22`
- Remote Path: This is very touchy and unintuitive. See the map below.

##### Rsync Local-to-Remote Dataset Path Mapping
| Local Path | Path on Monk |
|:-:|:-:|
| `/mnt/Media/HomeVideos/` | `/mnt/Backup/Backup/Media/Media/Video/HomeVideos` |
| `/mnt/Media/Recordings/` | `/mnt/Backup/Backup/Media/Media/Video/Recordings` |
| `/mnt/Media/Images/` | `/mnt/Backup/Backup/Media/Media/Images` |
| `/mnt/Tank/Text/` | `/mnt/Backup/Backup/Tank/Text` |
| `/mnt/Tank/Archive/` | `/mnt/Backup/Backup/Tank/Archive` |
| `/mnt/Tank/AppData/` | `/mnt/Backup/Backup/Tank/AppData` |

Validate that the path is correct by running `rsync -arz -v --dry-run $local_path admin@192.168.1.11:$remote_path`. If `sending incremental file list` is followed by a blank line and then the summary (like `sent N bytes, received M bytes, XY bytes/sec`), then you're golden. 

#### Schedule
- Schedule: `0 0 * * 0` "On Sundays at 00:00 (12:00 AM)"
- Recursive: True
- Enabled: True

> Note: Test then enable
> Rsync jobs should be tested manually with supervision before enabling for automated recurrence.

### ZFS Replication
- What and Where
  - Source Location: On this System.
    - Source: Check boxes for each of the following datasets:
      - `/mnt/Media/HomeVideos`
      - `/mnt/Media/Recordings`
      - `/mnt/Media/Images`
      - `/mnt/Tank/Text`
      - `/mnt/Tank/Archive`
      - `/mnt/Tank/AppData`
    - Recursive: False.
    - Replicate Custom Snapshots: False.
    - SSH Transfer Security: Encryption (This encrypts traffic in flight, not at rest on destination.)
    - Use Sudo For ZFS Commands: True.
  - Destination Location: On a Different System.
    - SSH Connection: admin@monk (See Note below.)
    - Destination: `Backup/Backup`
    - Encryption: False. 
  - Task Name: `Backup Non-Reproducible Datasets`
- When
  - Replication Schedule: Run On a Schedule
  - Schedule: Daily at 01:00 AM
  - Destination Snapshot Lifetime: Same as Source

> Note: SSH Connection with non-root remote user
> For ZFS-replication-over-SSH to work properly, the user on the remote system needs superuser permissions. To get superuser permissions in a scripted environment like a replication task, the remote user needs the "Allow all sudo commands with no password" option to be True. 
> On the remote system, navigate to Credentials -> Local Users -> `admin` -> Edit -> Authentication. Then set "Allow all sudo commands" and "Allow all sudo commands with no password" to True.

#### More Options
- Times: True
- Compress: True
- Archive: True
- Delete: True
- Quiet: False
- Preserve Permissions: False
- Preserve Extended Attributes: False
- Delay Updates: True

### S.M.A.R.T. Tests
- SHORT test for All Disks at 11:00 PM daily. 
  - This is scheduled such that it is unlikely to overlap with a snapshot task. 

## Configuring an SSH Connection to Remote TrueNAS System

1. Generate a keypair for the local system.
   1. Credentials -> Backup Credentials -> SSH Keypairs -> Add.
   2. Name the keypair like `<localuser>@<localhostname>` (e.g. `admin@paladin`).
   3. If a keypair already exists for this host (e.g. if generated manually via CLI), copy the private and public keys into their respective fields here. Otherwise, Generate Keypair.
   4. Click Save.
2. Configure the SSH Connection. 
   1. Credentials -> Backup Credentials -> SSH Connections -> Add.
   2. Name the connection like `<remoteuser>@<remotehostname>` (e.g. `admin@monk`. Note: My systems all use `admin` as the username. If you used names like `monkadmin` for the remote system, you would use `monkadmin` here.)
   3. Setup Method: Manual
   4. Authentication:
      1. Host: `192.168.1.11`
      2. Port: `22`
      3. Username: `admin`
      4. Private Key: `admin@paladin` (the keypair generated in step 1.)
      5. Remote Host Key: Click "Discover Remote Host Key"
      6. Connect Timeout (seconds): `2`

## Restore from Backup
TODO:
- Document procedure for restoring one file from most recent backup.
- Document procedure for restoring one dataset from most recent backup. 
- Document procedure for restoring many files from most recent backup.
- Document procedure for restoring one file from older backup.
- Document procedure for restoring one dataset from older backup.
- Document procedure for restoring many datasets from older backup.
- Build automation for regularly restoring from backup.
- Chaos engineering? 