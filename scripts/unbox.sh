#!/bin/bash
rand() {
  openssl rand -hex $1 | cut -c -$1
}
VMNAME=Windows
VBoxManage setextradata $VMNAME VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVendor "American Megatrends Inc"
VBoxManage setextradata $VMNAME VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVersion 2.1.0
VBoxManage setextradata $VMNAME VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor "ASUSTek Computer"
VBoxManage setextradata $VMNAME VBoxInternal/Devices/pcbios/0/Config/DmiSystemSerial $(rand 9)
VBoxManage setextradata $VMNAME VBoxInternal/Devices/ahci/0/Config/Port0/SerialNumber $(rand 20)
VBoxManage setextradata $VMNAME VBoxInternal/Devices/ahci/0/Config/Port0/FirmwareRevision $(rand 8)
VBoxManage setextradata $VMNAME VBoxInternal/Devices/ahci/0/Config/Port0/ModelNumber "SEAGATE ST3750525AS"
