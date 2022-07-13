# About
"Rackdown" is AWS slang for turning a rack of hosts off and on again. In this case, the "rack" refers to practically all components of the DC. Server, NAS, disk shelf, switches, router, PiHole, modem, APs, and desktops. This doc will consolidate previous docs and provide an overall shutdown and reboot procedure. 

# Overview (Dependency Graph)
```mermaid
flowchart TD;
	CLN["CenturyLink node"]<--Depends--ONT;
		ONT<--Cat5e-->Modem[ISP Modem/Router];
			Modem<--Cat5e-->Router[Ubiquiti EdgeRouter 10X];
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

## Booting the ONT
1. Unplug the 6-pin power plug. Wait 15 seconds.
2. Plug the power plug back in. Wait for the top three lights to be solid green.

## Booting the modem (Zyxel C3000Z)
1. Unplug the barrel power plug. Wait 15 seconds.
2. Plug the power plug back in. Wait for the "Power" and "WAN/LAN" lights to be solid green (the WAN/LAN light might flicker, that's okay. )

## Booting the Router (Ubiquiti EdgeRouter 10X)
1. Uplug the barrel power plug. Wait 15 seconds. 
2. Plug the power plug back in. Wait for the indicator LED to be solid white.

## Booting the Server
1. Shut down most services: `for app in ~/homelab/server/config/*; do echo "===== SHUTTING DOWN $app =====" && cd $app && docker-compose down; done`
2. Shut down Minecraft servers: `cd ~/homelab/server/config/minecraft && for service in ./*.yml; do echo "===== SHUTTING DOWN $service =====" && docker-compose -f $service down; done`
3. Shut down the host: `sudo shutdown now`. Wait 30 seconds.
4. Press the power button on the front of the chassis to begin booting. Take note of any POST beeps during this time. Wait for the host to be accessible via SSH. 
5. Check current running docker containers