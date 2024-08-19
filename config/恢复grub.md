安装其他的linux发行版，结果原来的grub被抢占了。现在的发行版，还都不自动刷新全部的启动菜单。

- 按F8进入UEFI启动菜单，选择最常用的fedora系统
- 以前grub的grub2-install方法，对于efi系统是无效的。虽然可以--force重建，但是会产生一个垃圾的新efi启动项目。
```
⭕ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1  57.8G  0 disk 
├─sda1        8:1    1  57.7G  0 part /run/media/eexpss/Ventoy
└─sda2        8:2    1    32M  0 part 
zram0       252:0    0     8G  0 disk [SWAP]
nvme0n1     259:0    0 465.8G  0 disk 
├─nvme0n1p1 259:1    0   100M  0 part 
├─nvme0n1p2 259:2    0    16M  0 part 
├─nvme0n1p3 259:3    0 167.9G  0 part 
├─nvme0n1p4 259:4    0 297.1G  0 part 
└─nvme0n1p5 259:5    0   718M  0 part 
nvme1n1     259:6    0 465.8G  0 disk 
├─nvme1n1p1 259:7    0    16M  0 part 
├─nvme1n1p2 259:8    0   383G  0 part 
├─nvme1n1p3 259:9    0   600M  0 part /boot/efi
├─nvme1n1p4 259:10   0  19.2G  0 part /home
├─nvme1n1p5 259:11   0  19.3G  0 part 
├─nvme1n1p6 259:12   0     1G  0 part /boot
├─nvme1n1p7 259:13   0  38.7G  0 part /
└─nvme1n1p8 259:14   0   3.9G  0 part 
⭕ sudo grub2-install /dev/nvme1n1p6
正在为 x86_64-efi 平台进行安装。
grub2-install：错误： This utility should not be used for EFI platforms because it does not support UEFI Secure Boot. If you really wish to proceed, invoke the --force option.
Make sure Secure Boot is disabled before proceeding.
⭕ sudo grub2-install /dev/nvme1n1p6 --force
正在为 x86_64-efi 平台进行安装。
安装完成。没有报告错误。
```

- 使用efibootmgr来调整efi启动。

```
🔴 efibootmgr -c -L "Fedora" -l '\EFI\fedora\shimx64.efi'
efibootmgr: ** Warning ** : Boot0009 has same label Fedora
Could not prepare Boot variable: No such file or directory
🔴 efibootmgr
BootCurrent: 0001
Timeout: 1 seconds
BootOrder: 0001,0002,0000,0003
Boot0000* Windows Boot Manager	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d0000006f000100000010000000040000007fff0400
Boot0001* fedora	HD(3,GPT,d8f40d21-76b4-4388-aeac-d55b5e6c924d,0x35552000,0x12c000)/\EFI\FEDORA\GRUBX64.EFI
Boot0002* deepin	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\DEEPIN\SHIMX64.EFI
Boot0003* Fedora	HD(3,GPT,d8f40d21-76b4-4388-aeac-d55b5e6c924d,0x35552000,0x12c000)/\EFI\FEDORA\SHIMX64.EFI0000424f
Boot0009* Fedora	HD(3,GPT,d8f40d21-76b4-4388-aeac-d55b5e6c924d,0x35552000,0x12c000)/\EFI\FEDORA\SHIMX64.EFI0000424f

🔴 efibootmgr -v
BootCurrent: 0001
Timeout: 1 seconds
BootOrder: 0002,0001,0000,0009
Boot0000* Windows Boot Manager	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d0000006f000100000010000000040000007fff0400
      dp: 04 01 2a 00 01 00 00 00 00 08 00 00 00 00 00 00 00 20 03 00 00 00 00 00 4f b8 a4 d9 2a d0 9b 41 94 ec f7 14 45 1a f4 2f 02 02 / 04 04 46 00 5c 00 45 00 46 00 49 00 5c 00 4d 00 49 00 43 00 52 00 4f 00 53 00 4f 00 46 00 54 00 5c 00 42 00 4f 00 4f 00 54 00 5c 00 42 00 4f 00 4f 00 54 00 4d 00 47 00 46 00 57 00 2e 00 45 00 46 00 49 00 00 00 / 7f ff 04 00
    data: 57 49 4e 44 4f 57 53 00 01 00 00 00 88 00 00 00 78 00 00 00 42 00 43 00 44 00 4f 00 42 00 4a 00 45 00 43 00 54 00 3d 00 7b 00 39 00 64 00 65 00 61 00 38 00 36 00 32 00 63 00 2d 00 35 00 63 00 64 00 64 00 2d 00 34 00 65 00 37 00 30 00 2d 00 61 00 63 00 63 00 31 00 2d 00 66 00 33 00 32 00 62 00 33 00 34 00 34 00 64 00 34 00 37 00 39 00 35 00 7d 00 00 00 6f 00 01 00 00 00 10 00 00 00 04 00 00 00 7f ff 04 00
Boot0001* fedora	HD(3,GPT,d8f40d21-76b4-4388-aeac-d55b5e6c924d,0x35552000,0x12c000)/\EFI\FEDORA\GRUBX64.EFI
      dp: 04 01 2a 00 03 00 00 00 00 20 55 35 00 00 00 00 00 c0 12 00 00 00 00 00 21 0d f4 d8 b4 76 88 43 ae ac d5 5b 5e 6c 92 4d 02 02 / 04 04 34 00 5c 00 45 00 46 00 49 00 5c 00 46 00 45 00 44 00 4f 00 52 00 41 00 5c 00 47 00 52 00 55 00 42 00 58 00 36 00 34 00 2e 00 45 00 46 00 49 00 00 00 / 7f ff 04 00
Boot0002* deepin	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\DEEPIN\SHIMX64.EFI
      dp: 04 01 2a 00 01 00 00 00 00 08 00 00 00 00 00 00 00 20 03 00 00 00 00 00 4f b8 a4 d9 2a d0 9b 41 94 ec f7 14 45 1a f4 2f 02 02 / 04 04 34 00 5c 00 45 00 46 00 49 00 5c 00 44 00 45 00 45 00 50 00 49 00 4e 00 5c 00 53 00 48 00 49 00 4d 00 58 00 36 00 34 00 2e 00 45 00 46 00 49 00 00 00 / 7f ff 04 00
      dp: 04 01 2a 00 03 00 00 00 00 20 55 35 00 00 00 00 00 c0 12 00 00 00 00 00 21 0d f4 d8 b4 76 88 43 ae ac d5 5b 5e 6c 92 4d 02 02 / 04 04 34 00 5c 00 45 00 46 00 49 00 5c 00 46 00 45 00 44 00 4f 00 52 00 41 00 5c 00 53 00 48 00 49 00 4d 00 58 00 36 00 34 00 2e 00 45 00 46 00 49 00 00 00 / 7f ff 04 00
    data: 00 00 42 4f
🔴 efibootmgr -b 0009 -B
BootCurrent: 0001
Timeout: 1 seconds
BootOrder: 0002,0001,0000
Boot0000* Windows Boot Manager	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d0000006f000100000010000000040000007fff0400
Boot0001* fedora	HD(3,GPT,d8f40d21-76b4-4388-aeac-d55b5e6c924d,0x35552000,0x12c000)/\EFI\FEDORA\SHIMX64.EFI0000424f
Boot0002* deepin	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\DEEPIN\SHIMX64.EFI
🔴 grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
Generating grub configuration file ...
Found Deepin 23 (23) on /dev/nvme0n1p5
Found Windows Boot Manager on /dev/nvme1n1p1@/efi/Microsoft/Boot/bootmgfw.efi
Adding boot menu entry for UEFI Firmware Settings ...
done
🔴 efibootmgr -o 0001,0002,0000
BootCurrent: 0001
Timeout: 1 seconds
BootOrder: 0001,0002,0000
Boot0000* Windows Boot Manager	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d0000006f000100000010000000040000007fff0400
Boot0001* fedora	HD(3,GPT,d8f40d21-76b4-4388-aeac-d55b5e6c924d,0x35552000,0x12c000)/\EFI\FEDORA\SHIMX64.EFI0000424f
Boot0002* deepin	HD(1,GPT,d9a4b84f-d02a-419b-94ec-f714451af42f,0x800,0x32000)/\EFI\DEEPIN\SHIMX64.EFI
```

