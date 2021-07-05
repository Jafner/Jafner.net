#!/usr/bin/env bash
# based on: https://wiki.5e.tools/index.php/5eTools_Install_Guide
source .env
cd ${DOCKER_DATA}/htdocs

FN=`curl -s -I https://get.5e.tools/src/|grep filename|cut -d"=" -f2 | awk '{print $1}'`
FN=${FN//[$'\t\r\n"']}
echo "FN: $FN"
FN_IMG=`curl -s -I https://get.5e.tools/img/|grep filename|cut -d"=" -f2 | awk '{print $1}'`
FN_IMG=${FN_IMG//[$'\t\r\n"']}
echo "FN_IMG: $FN_IMG"
VER=`basename ${FN} ".zip"|sed 's/5eTools\.//'`
echo "VER: $VER"
CUR=$(<version)

echo " === Remote version: $VER"
echo " === Local version: $CUR"

if [ "$VER" != "$CUR" ]
then
  echo " === Local version outdated, updating..."
  echo -n $VER > version

  rm ./index.html 2> /dev/null || true

  echo " === Downloading new remote version..."
  cd ./download/
  curl --progress-bar -O -J https://get.5e.tools/src/ -C -
  curl --progress-bar -O -J https://get.5e.tools/img/ -C -
  cd ..

  echo " === Extracting site..."
  7z x ./download/$FN -o./ -y
 echo " === Extracting images..."
 7z x ./download/$FN_IMG -o./img -y
 mv ./img/tmp/5et/img/* ./img
 rm -r ./img/tmp

  echo " === Configuring..."
  find . -name \*.html -exec sed -i 's/"width=device-width, initial-scale=1"/"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/' {} \;
  cp 5etools.html index.html
  sed -i 's/<head>/<head>\n<link rel="apple-touch-icon" href="icon\/icon-512.png">/' index.html
  sed -i 's/navigator.serviceWorker.register("\/sw.js/navigator.serviceWorker.register("sw.js/' index.html
  sed -i 's/navigator.serviceWorker.register("\/sw.js/navigator.serviceWorker.register("sw.js/' 5etools.html

  echo " === Cleaning up downloads"
  find ./download/ -type f ! -name "*.${VER}.zip" -exec rm {} +

  echo " === Done!"
else
  echo " === Local version matches remote, no action."
fi
