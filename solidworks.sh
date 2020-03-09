VMNAME=Windows
RAND9=aaaaaaaaa
RAND20=aaaaaaaaaaaaaaaaaaaa
RAND8=aaaaaaaa
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVendor" "American Megatrends Inc"
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVersion" "2.1.0"
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor" "ASUSTek Computer"
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSerial" $RAND9
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/ahci/0/Config/Port0/SerialNumber" $RAND20
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/ahci/0/Config/Port0/FirmwareRevision" $RAND8
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/ahci/0/Config/Port0/ModelNumber" "SEAGATE ST3750525AS"
