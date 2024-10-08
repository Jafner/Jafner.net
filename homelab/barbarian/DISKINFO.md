We can get each drive's serial number, power on hours, and manufacture date with the following one-liner:

```
for dev in {b..y}; \
  do echo "### /dev/sd$dev" && \
  sudo smartctl -a /dev/sd$dev | awk '/Serial number:/{serial=$NF} /hours:minutes/{powerontime=$NF} {FS="\n"}/Manufactured in /{manufacture=$NF}END{print serial; print  powerontime; print manufacture; printf "\n"}'; \
done
```

Make sure to update this list *only* when a disk is newly installed. Also note the date of installation for the disk.

Or, if you're only updating one drive:
1. Set the `$dev` variable to the drive letter you want to check (e.g. for `/dev/sdr`, use `dev=r`)
2. Run the one-liner: `smartctl -a /dev/sd$dev | awk '/Serial number:/{serial=$NF} /hours:minutes/{powerontime=$NF} {FS="\n"}/Manufactured in /{manufacture=$NF}END{print serial; print  powerontime; print manufacture; printf "\n"}'`

## Disk Info

### /dev/sdb
Serial number:        VJGPS30X
Accumulated power on time, hours:minutes 48962:49
Manufactured in week 10 of year 2017

### /dev/sdc
Serial number:        VK0ZD6ZY
Accumulated power on time, hours:minutes 32709:42
Manufactured in week 03 of year 2017

### /dev/sdd (INSTALLED 2023/07/20)
Serial number:        VKJWPAEX
Accumulated power on time, hours:minutes 44760:00
Manufactured in week 22 of year 2016

### /dev/sde
Serial number:        VJG2PVRX
Accumulated power on time, hours:minutes 47505:55
Manufactured in week 36 of year 2016

### /dev/sdf
Serial number:        VJGR6TNX
Accumulated power on time, hours:minutes 48957:25
Manufactured in week 10 of year 2017

### /dev/sdg
Serial number:        2EG14YNJ
Accumulated power on time, hours:minutes 32640:40
Manufactured in week 49 of year 2014

### /dev/sdh (INSTALLED 2023/06/25)
Serial number:        VJGJVTZX
Accumulated power on time, hours:minutes 35808:32
Manufactured in week 07 of year 2017

### /dev/sdi
Serial number:        VJG1H9UX
Accumulated power on time, hours:minutes 47504:12
Manufactured in week 33 of year 2016

### /dev/sdj (INSTALLED 2023/06/24)
Serial number:        VJGJUWNX
Accumulated power on time, hours:minutes 35913:53
Manufactured in week 07 of year 2017

### /dev/sdk
Serial number:        2EGXD27V
Accumulated power on time, hours:minutes 35390:13
Manufactured in week 44 of year 2015

### /dev/sdl (INSTALLED 2023/06/25)
Serial number:        VJGJAS1X
Accumulated power on time, hours:minutes 35811:54
Manufactured in week 07 of year 2017

### /dev/sdm
Serial number:        VJG2UTUX
Accumulated power on time, hours:minutes 47569:09
Manufactured in week 36 of year 2016

### /dev/sdn
Serial number:        VJGRGD2X
Accumulated power on time, hours:minutes 49043:40
Manufactured in week 10 of year 2017

### /dev/sdo
Serial number:        001526PL8AVV        2EGL8AVV
Accumulated power on time, hours:minutes 55129:17
Manufactured in week 26 of year 2015

### /dev/sdp
Serial number:        2EKA903X
Accumulated power on time, hours:minutes 45174:35
Manufactured in week 53 of year 2015

### /dev/sdq
Serial number:        VJGRRG9X
Accumulated power on time, hours:minutes 49911:22
Manufactured in week 10 of year 2017

### /dev/sdr
Serial number:        VKH40L6X
Accumulated power on time, hours:minutes 46115:13
Manufactured in week 10 of year 2016

### /dev/sdr (INSTALLED 2023/07/19)
Serial number:        VJGK56KX
Accumulated power on time, hours:minutes 35870:47
Manufactured in week 07 of year 2017

### /dev/sds
Serial number:        001528PNPVWV        2EGNPVWV
Accumulated power on time, hours:minutes 23197:56
Manufactured in week 28 of year 2015

### /dev/sdt
Serial number:        2EKATR2X
Accumulated power on time, hours:minutes 45173:20
Manufactured in week 53 of year 2015

### /dev/sdu
Serial number:        VKH3Y3XX
Accumulated power on time, hours:minutes 57672:16
Manufactured in week 10 of year 2016

### /dev/sdv
Serial number:        001703PV9N8V        VLKV9N8V
Accumulated power on time, hours:minutes 51699:11
Manufactured in week 03 of year 2017

### /dev/sdw
Serial number:        001708P4W2VV        R5G4W2VV
Accumulated power on time, hours:minutes 26289:03
Manufactured in week 08 of year 2017

### /dev/sdx
Serial number:        2EKA92XX
Accumulated power on time, hours:minutes 45175:01
Manufactured in week 53 of year 2015

### /dev/sdy
Serial number:        VKGW5YGX
Accumulated power on time, hours:minutes 57740:50
Manufactured in week 09 of year 2016

## Gettin Graphic

```
for dev in {b..y}; \
  do smartctl -a /dev/sd$dev | awk '/Serial number:/{serial=$NF} /hours:minutes/{powerontime=$NF} /Manufactured in /{manufacture=$NF}END{print serial; print  powerontime; print manufacture; printf "\n"}'; \
done
```