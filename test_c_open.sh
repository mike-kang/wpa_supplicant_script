#!/bin/sh

#/wpa_cli -i wlan0 disconnect
#./wpa_cli -i wlan0 remove_network all

echo -n "Please, Input the SSID?"
read SSID

num=$(./wpa_cli -i wlan0 add_network)
SSID="\"${SSID}\""

./wpa_cli -i wlan0 set_network $num ssid $SSID
./wpa_cli -i wlan0 set_network $num key_mgmt NONE
./wpa_cli -i wlan0 select_network $num
./wpa_cli -i wlan0 enable_network $num

sleep 5
./wpa_cli -i wlan0 status

