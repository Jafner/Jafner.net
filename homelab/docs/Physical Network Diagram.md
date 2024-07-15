# Full Network Diagram
```mermaid
flowchart TD;
	Internet<--Symmetrical 1Gbit Fiber-->ONT;
		ONT<--Cat5e-->Router;
			Router<--Cat5e-->switch_homelab[NetGear 8-Port Switch for Homelab];
				switch_homelab<--Cat6-->desktop_joey[Joey's Desktop];
				switch_homelab<--Cat5-->desktop_bridget[Bridget's Desktop];
				switch_homelab<--Cat6-->NAS;
					NAS<--SFP+ DAC-->Desktop;
					NAS<--SFP+ DAC-->Server;
				switch_homelab<--Cat6-->Server;
				switch_homelab<--Cat6-->Seedbox;
				switch_homelab<--Cat5e-->Pihole;
			Router<--Cat5e-->switch_basementtv[TP-Link 5-Port Switch for Basement TV];
				switch_basementtv<--Cat6-->desktop_maddie[Maddie's Desktop];
				switch_basementtv<--Cat5e-->client_tv_downstairs[Downstairs TV];
			Router<--Cat6-->wap_basement[Ubiquiti Unifi U6-Lite];
				wap_basement<--Wifi6 2.4/5GHz-->clients_wireless_basement[Basement Wireless Clients];
			Router<--Cat6-->wap_upstairs[Ubiquiti Unifi UAP-AC-LR];
				wap_upstairs<--Wifi5 2.4/5GHz-->clients_wireless_upstairs[Upstairs Wireless Clients];
			Router<--Cat6-->desktop_mom[Mom's Desktop];
			Router<--Cat6-->desktop_dad[Dad's Desktop];
			Router<-->desktop_gus[Gus' Desktop];	
```
# Router Interfaces
| Interface | Connected to |
|:---------:|:------------:|
| `eth0` | (Upstream) Zyxel C3000Z modem | 
| `eth1` | Reserved for `192.168.2.1/24` |
| `eth2` | Homelab switch |
| `eth3` | Mom's office PC |
| `eth4` | Gus' PC |
| `eth5` | (Disconnected) Outlets behind upstairs couch |
| `eth6` | Maddie's office switch |
| `eth7` | Dad's office PC |
| `eth8` | (PoE, injected) Upstairs wireless AP |
| `eth9` | (PoE, native) Homelab wireless AP |
| `pppoe0` | PPPoE layer pysically on `eth0` |
| `switch0` | Internal router switch |