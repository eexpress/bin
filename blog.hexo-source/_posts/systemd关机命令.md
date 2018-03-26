System Commands:
> from `man systemctl`. TAB completion can be work after `sudo su`.

command|commit
:--|--:
is-system-running|		Check whether system is fully running
default|				Enter system default mode
rescue|					Enter system rescue mode
emergency|				Enter system emergency mode
halt|					Shut down and halt the system
\***poweroff**|			Shut down and power-off the system
reboot [ARG]|			Shut down and reboot the system
kexec|					Shut down and reboot the system with kexec
exit [EXIT_CODE]|		Request user instance or container exit
switch-root ROOT [INIT]|Change to a different root file system
\***suspend**|			Suspend the system
\***hibernate**|			Hibernate the system
\***hybrid-sleep**|		Hibernate and suspend the system
