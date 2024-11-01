{ lib
, mkWindowsAppNoCC
, wine
, makeDesktopItem 
, copyDesktopItems
}: mkWindowsAppNoCC rec {
  inherit wine;

  pname = "ecuflash";
  version = "1.44";
  version_raw = "1444870";
  
  src = builtins.fetchurl { 
    sha256 = "sha256-6SQtiIJTD8MgFk8T5BB87/nIYvW9Lmbevb6+SJX/+gs="; 
    url = "https://www.tactrix.com/downloads/ecuflash_1444870_win.exe"; 
  };
  dontUnpack = true;   
  wineArch = "win64";
  enableInstallNotification = true;

  fileMapDuringAppInstall = false;
  persistRegistry = true;
  persistRuntimeLayer = true;
  inputHashMethod = "store-path";
  nativeBuildInputs = [ copyDesktopItems ];
  winAppInstall = ''
    d="$WINEPREFIX/drive_c/Program Files (x86)/OpenECU/${pname}/"

    mkdir -p "$d"
    cp ${src} "$d/${pname}_${version_raw}.exe"
    wine "$WINEPREFIX/drive_c/Program Files (x86)/OpenECU/${pname}/${pname}_${version_raw}.exe"
  '';
  winAppPreRun = ''
  '';
  winAppRun = ''
    echo "src: ${src}"
    ls "$WINEPREFIX/drive_c/Program Files (x86)/OpenECU/${pname}"
    wine "$WINEPREFIX/drive_c/Program Files (x86)/OpenECU/EcuFlash/${pname}.exe"
  '';
  winAppPostRun = "";
  installPhase = ''
    runHook preInstall

    ln -s $out/bin/.launcher $out/bin/${pname}

    runHook postInstall
  '';
  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    mimeTypes = [ "application/octet-stream" ];
    desktopName = "EcuFlash";
    genericName = "ROM Editor";
    categories = [ "Development" "Electronics" "Java" ];
  };
  meta = with lib; {
    description = "EcuFlash is Tactrix' free software used with the Openport 2.0 to give you the power to tune and reflash many Subaru and Mitsubishi vehicles.";
    homepage = "https://www.tactrix.com/";
    license = {
      url = "https://www.tactrix.com/index.php?option=com_content&view=article&id=79:eula&catid=36:downloads-ecuflash&Itemid=57";
      free = false;
      redistributable = true;
    };
    maintainers = with maintainers; [ jafner ];
    platforms = [ "x86_64-linux" ];
  };
}