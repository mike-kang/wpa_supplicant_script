#!/bin/sh

echo -n "Please, input method(pbc/pin)?"
read METHOD
echo -n "Please, input role(go/gc)?"
read ROLE
if [ $ROLE == "go" ]; then
  GO_INTENT=14
else
  GO_INTENT=1
fi

p2p_if=$(ifconfig | grep p2p- | awk -F: '{print $1}')
if [ ! -z $p2p_if ]; then
  echo "remove p2p group interface $p2p_if"
  ./wpa_cli -i $p2p_if p2p_group_remove $p2p_if
fi

echo "Please, turn on the p2p serch of peer"
sleep 4

declare -i i
while :
do
  echo "try to find for 5 secs"
  ./wpa_cli -i wlan0 p2p_find 5 > /dev/null 
  sleep 5
  p2p_peer_addrs=$(./wpa_cli -i wlan0 p2p_peers)
  
  if [ -z "$p2p_peer_addrs" ]; then
    echo "not found!"
    continue
  else
    i=0
    for addr in $p2p_peer_addrs
    do
      name=$(./wpa_cli -i wlan0 p2p_peer $addr | grep device_name | awk -F= '{print $2}')
      echo "peer[$i] $addr [$name]"
      peer_addr[$i]=$addr 
      i=$i+1
    done 
    echo -n "Please, select peer?" 
    read peer
    if [ ! -z $peer ]; then
      break
    fi
  fi
done

./wpa_cli -i wlan0 p2p_connect ${peer_addr[$peer]} $METHOD go_intent=$GO_INTENT
if [ $METHOD == "pbc" ]; then
  echo -n "Please, push the button of peer, and press Enter"
else
  echo ""
  echo -n "Please, input the pin to peer, and press Enter"
fi

read answer
sleep 3
p2p_if=$(ifconfig | grep p2p- | awk -F: '{print $1}')
if [ -z $p2p_if ]; then
  echo "fail"
  exit
fi

./wpa_cli -i $p2p_if status




