We can get each drive's serial number, power on hours, and manufacture date with the following one-liner:

```
for dev in {a..e}; \
  do echo "### /dev/sd$dev" && \
  sudo smartctl -a /dev/sd$dev
done
```

Make sure to update this list *only* when a disk is newly installed. Also note the date of installation for the disk.

Or, if you're only updating one drive:
1. Set the `$dev` variable to the drive letter you want to check (e.g. for `/dev/sdr`, use `dev=r`)
2. Run the one-liner: `smartctl -a /dev/sd$dev'`
