#!/bin/bash

{
  # Step 1. Check and print variable values:
  echo " # Check and print variables:"
  echo "   # PUID:PGID: $PUID:$PGID"
  echo "   # OFFLINE_MODE: $OFFLINE_MODE"
  echo "   # GET_IMAGES: $GET_IMAGES"
  echo "   # HOMEBREW_URLS: $HOMEBREW_URLS"
  # $HOMEBREW_PATH; host path containing homebrew json files to load
  # $CONTENT_BLOCKLIST_FILE; file automatically imported to block content
}

{
  # Step 2. Assert ownership of site files.
  echo " # Setting ownership of site directory"
  chown -R $PUID:$PGID /usr/local/apache2/htdocs
}

{
  # Step 3. Check for offline mode. 
  #   - If OFFLINE_MODE is set to TRUE, we check if the site files directory 
  #     has a valid 5eTools version file.
  #     - If there is a valid version file, we start the server.
  #     - If there is no valid version, we exit with error.
  #   - Else we continue to step 4.
  echo -n " # Checking OFFLINE_MODE: "
  if [ "$OFFLINE_MODE" = "TRUE" ]; then 
    echo "enabled"
    echo "   # Will try to launch from local files."
    echo -n "   # Checking local version: "
    if [ -f /usr/local/apache2/htdocs/package.json ]; then
      VERSION=$(jq -r .version package.json) # Get version from package.json
      echo "$VERSION"
      echo "   # Starting!"
      httpd-foreground
    else
      echo "None found."
      echo "   # No local version detected. Exiting."
      exit 1
    fi
  fi
}

{
  # Step 4. Check for site update.
  #   - First we gather facts: local version, remote version, GET_IMAGES bool.
  #   - Check local and remote version tags of main site 
  
  cd /usr/local/apache2/htdocs

  echo " # Checking version info"
  echo -n "   # Local version: "
  if ! [[ -f package.json ]]; then
      echo "None"
  else
      CURRENT_RELEASE_VERSION="v$(jq -r .version package.json)"
      echo "$CURRENT_RELEASE_VERSION"
  fi

  echo -n "   # Remote version: "
  LATEST_RELEASE_VERSION=$(curl -s https://api.github.com/repos/5etools-mirror-2/5etools-mirror-2.github.io/releases/latest | grep tag_name | cut -d':' -f2 | tr -d \" | tr -d \,| head -n 1 | xargs)
  echo "$LATEST_RELEASE_VERSION"
}

{
  # Step 5. Handle image files.
  #   - Check if images are wanted, present:
  #     - Not wanted, not present: Skip.
  #     - Not wanted, present: Delete.
  #     - Wanted, not present: Get.
  #     - Wanted, present: Update.
  echo " # Checking for image files"
  if [[ "$GET_IMAGES" == "FALSE" ]]; then
    if ! [[ -f /usr/local/apache2/htdocs/img/.version ]]; 
      echo "   # Image files not wanted, not present. Skipping."
    else
      echo "   # Image files not wanted, but found locally. Deleting."
      rm -rf /usr/local/apache2/htdocs/img
    fi
  else
    if ! [[ -f /usr/local/apache2/htdocs/img/.version ]]; 
      echo "   # Image files wanted, not present. Downloading."
      # TODO: Download image files. Create `.version` file for images.
      IMG_LATEST_RELEASE_VERSION=$(curl -s https://api.github.com/repos/5etools-mirror-2/5etools-img/releases/latest | grep tag_name | cut -d':' -f2 | tr -d \" | tr -d \,| head -n 1 | xargs)
      echo "     # Getting list of img release files"
      IMG_URLS=$(curl -s https://api.github.com/repos/5etools-mirror-2/5etools-img/releases/latest | grep browser_download_url | cut -d':' -f2,3 | tr -d \" | xargs)
      echo "     # Downloading img release files"
      for file in $(echo $IMG_URLS); do echo "Downloading file: $file"; wget --directory-prefix=/tmp/ "$file"; done 
      echo "     # Extracting img release archives"
      unzip -d /usr/local/apache2/htdocs/img/ -n /tmp/img-*.zip
      echo "$IMAGE_LATEST_RELEASE_VERSION" > /usr/local/apache2/htdocs/img/.version
      echo "     # Cleaning up archives"
      rm /tmp/img-*
    else
      echo "   # Image files wanted, and found locally. Checking for update."
      # TODO: Diff local tag to remote latest. If different, download update.
      # $1 = Repo path like 5etools-mirror-2/5etools-img
      # $2 = Current tag like v1.209.0
      # $3 = Compare tag like v1.209.3
      # Returns bool; 1 if tags are identical
      IMG_REPO=5etools-mirror-2/5etools-img
      IMG_CURRENT_RELEASE_VERSION=$(cat /usr/local/apache2/htdocs/img/.version)
      IMG_LATEST_RELEASE_VERSION=$(curl -s https://api.github.com/repos/5etools-mirror-2/5etools-img/releases/latest | grep tag_name | cut -d':' -f2 | tr -d \" | tr -d \,| head -n 1 | xargs)
      TESTURL=${"https://github.com/$IMG_REPO/compare/$IMG_CURRENT_RELEASE_VERSION..$IMG_LATEST_RELEASE_VERSION"}
      curl -s $TESTURL | grep "There isn’t anything to compare"
      DIFFERENT=$?
      if [[ "$DIFFERENT" == "1" ]]; then
        echo "new images, re-downloading image repo."
      else
        echo "no new images, skipping update."
      fi
    fi
  fi


  if [[ "$CURRENT_RELEASE_VERSION" == "$LATEST_RELEASE_VERSION" ]]; then
      echo "   # Downloading latest release"
      
  fi
}

{
  # Step 6. Update main site.
  wget -O /tmp/5etools.zip $LATEST_RELEASE_URL
  find /usr/local/apache2/htdocs/ -path ./homebrew -prune -o -type f -exec rm "{}" \;
  unzip -d /usr/local/apache2/htdocs/ -n /tmp/5etools.zip
  rm /tmp/5etools.zip
}

if [[ -f /usr/local/apache2/htdocs/img/.version ]]
# check for local image files in the img/ directory

# get image files
if [[ "$GET_IMAGES"=="TRUE" ]]; then
    
fi
