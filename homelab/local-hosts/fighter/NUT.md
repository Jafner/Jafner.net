# NUT Configuration Details

1. `sudo apt-get install nut`
2. `lsusb` to get ID of UPS over USB, returned `Bus 001 Device 005: ID 0463:ffff MGE UPS Systems UPS`
3. `sudo nano /etc/nut/ups.conf`. Add to bottom of file:
```ini
[EATON5PX1500RT]
driver = usbhid-ups
desc = "5PX1500RT"
port = auto
vendorid = 0463
productid = ffff
```
4. `sudo nano /etc/nut/upsd.conf`. Add to bottom of file: `LISTEN 0.0.0.0 3493`.
5. `sudo nano /etc/nut/upsd.users`. Add to bottom of file (replace <PASSWORD> with strong password): 
```ini
[upsmon]
  password = <PASSWORD>
  upsmon primary
```
6. `sudo nano /etc/nut/upsmon.conf`. Add to bottom of file (replace <PASSWORD> with password from step 5.): `MONITOR EATON5PX1500RT@localhost 1 upsmon <PASSWORD> primary`
7. `sudo nano /etc/nut/nut.conf`. Find line with `MODE=none` and replace with `MODE=netserver`.
8. `sudo systemctl restart nut-server.service`.
9. `sudo systemctl restart nut-monitor.service`.
10. `upsc EATON5PX1500RT` to get printout of current data from UPS.

Done!

---

Followed [this guide](https://pimylifeup.com/raspberry-pi-nut-server/).