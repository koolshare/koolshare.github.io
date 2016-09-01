#! /bin/sh
# ====================================变量定义====================================
eval `dbus export swap`

usb_disk=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`

sleep 2
if [ -f $usb_disk/swapfile ]
then
  echo -e "Mounting swap file..."
  swapon $usb_disk/swapswapfile
else
  echo -e "Swap file not found or $usb_disk is not mounted..."
fi