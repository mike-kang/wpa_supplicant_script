#!/bin/sh

./wpa_cli -i wlan0 disconnect
./wpa_cli -i wlan0 remove_network all

echo -n "Please, Input the SSID?"
read SSID
echo -n "Please, Input the Key?"
read KEY

num=$(./wpa_cli -i wlan0 add_network)
SSID="\"${SSID}\""
KEY="\"${KEY}\""

./wpa_cli -i wlan0 set_network $num ssid $SSID
./wpa_cli -i wlan0 set_network $num key_mgmt WPA-PSK
./wpa_cli -i wlan0 set_network $num pairwise CCMP
./wpa_cli -i wlan0 set_network $num psk $KEY
./wpa_cli -i wlan0 enable_network $num
./wpa_cli -i wlan0 select_network $num

sleep 5
./wpa_cli -i wlan0 status

