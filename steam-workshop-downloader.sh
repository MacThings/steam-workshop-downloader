#!/bin/bash
#

if [[ "$1" = "" ]]; then
  echo -e "\nUsage:\n"
  echo -e "./steam-workshop-downloader.sh WORKSHOP_ID\n"
  exit
fi

### Fit to your needs ###
steam_dir="$HOME/.steam/debian-installation/steamapps/workshop/content" 
download_dir="$HOME/Downloads"
###

workshop_id="$1"
html_source=$( curl -silent "https://steamcommunity.com/sharedfiles/filedetails/?id=$workshop_id" )
app_id=$( echo "$html_source" | grep "data-appid" | sed -e 's/.*data-appid="//g' -e 's/\">//g' -e 's/\r//g' )
title=$( echo "$html_source" | grep "workshopItemTitle" | sed -e 's/.*">//g' -e 's/<\/.*//g' )

echo -e "Connecting steam ...\n"

if steamcmd +login anonymous +workshop_download_item $app_id $workshop_id +quit > /dev/null; then
  echo -e "Done\n"
else
  echo -e "\nAn error has occured. Please check Workshop ID and try again.\n"
  exit
fi

echo -e "Zipping content ...\n"
echo "$title"

cd "$steam_dir/$app_id"

zip -rq "$HOME/Downloads/$title.zip" "$workshop_id"

rm -r "$steam_dir/$app_id/$workshop_id"

echo -e "\nFile created:\n$HOME/Downloads/$title.zip\n"
