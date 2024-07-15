| Device | Max draw (W) | Cost/mo.* |
|:------:|:------------:|:--------:|
| **Networking** | **Total ~60W** | **$2.12** |
| ISP ONT |
| ISP Modem ([Zyxel c3000z](https://www.centurylink.com/content/dam/home/help/downloads/internet/c3000z-datasheet.pdf)) | [10.4W](https://www.centurylink.com/home/help/internet/modems-and-routers/modem-energy-efficiency.html) | $0.34
| Router ([Ubiquiti Edgerouter 10X](https://dl.ubnt.com/datasheets/edgemax/EdgeRouter_DS.pdf)) | 8W (excl. PoE) | $0.26 |
| AP ([Ubiquiti UAP-AC-LR](https://dl.ubnt.com/datasheets/unifi/UniFi_AC_APs_DS.pdf)) | 6.5W | $0.21 |
| AP ([Ubiquiti U6-Lite](https://dl.ui.com/ds/u6-lite_ds.pdf)) | 12W | $0.39 |
| Network Switch (Estimate) | 7W | $0.23 per switch
| **Hosts** | **Total 310W idle / 520W load** | **$13.56** |
| PiHole | 3.8W | $0.12 |
| Server | 36W idle / 136W load | $1.18 / $1.99 / **$2.81** / $3.62 / $4.44 |
| Seedbox | 30W idle / 85W load |  $0.98 / $1.43 / **$1.88** / $2.33 / $2.78 | 
| NAS | 90W idle / 146W load | $2.94 / $3.40 / $3.85 / $4.31 / $4.77 |
| Disk shelf | ~45W empty / 150W current / ~213W full | $1.47 empty / $4.90 current / $6.96 full |
\* Devices with high variance calculated at intervals of 25% max load (0%, 25%, 50%, 75%, 100%)

## Math
1. Assuming ([\$0.045351/kWh](https://www.mytpu.org/wp-content/uploads/All-Schedules-2020_Emergency-Rate-Delay.pdf) * (30 days per month * 24 hours per day)) / 1000W/kW = $`0.032653`/WM (dollars per watt month)