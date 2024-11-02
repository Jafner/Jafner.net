# A Nix Package for Tactrix EcuFlash 
> EcuFlash is a general-purpose ECU reflashing and editing tool that supports an [ever-growing list](http://openecu.org/index.php?title=EcuFlash:VehicleSupport) of vehicles. EcuFlash uses the [OpenPort](http://openecu.org/index.php?title=OpenPort) vehicle interface to   reflash vehicles via the [OBDII port](http://en.wikipedia.org/wiki/On_Board_Diagnostics). EcuFlash also allows you to edit ECU data (known as 'maps' or 'tables') in a human-readable format using a [XML-based](http://en.wikipedia.org/wiki/XML) definition system to translate the data. With properly setup definitions, the ROM from any vehicle can be edited. Future plans for EcuFlash include logging support / overlay, and live tuning.

- [Tactrix.com](https://www.tactrix.com/index.php?option=com_content&view=category&layout=blog&id=36&Itemid=57)

This project attempts to create a reproducible package for running Tactrix' Windows-only software on Linux. 

# Usage
`nix-ecuflash` is a wine-wrapped Windows application. You can run it with:  

```sh
nix shell "github:Jafner/Jafner.net?dir=projects/nix-ecuflash#ecuflash"
```

# Installation
In 2024, I assume you're using flakes. 


Start by adding this flake as an input:
**Flake.nix**
```nix 
inputs = { 
    nix-ecuflash.url = "github:Jafner/Jafner.net?dir=projects/nix-ecuflash";
};
```

And then reference the package in a package list:

**home.nix**
```nix
home.packages = [
    inputs.nix-ecuflash.packages."x86_64-linux".ecuflash
];
```

Or 

**configuration.nix**
```nix
environment.systemPackages = [
    inputs.nix-ecuflash.packages."x86_64-linux".ecuflash
];
```