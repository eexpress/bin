Name:           showit
Summary:        Show SVG PNG TXT on screen. Use mouse and/or Meta Key to Zoom/Scale/Rotate/Change_Color/Change_Layer.
Version:        0.6.1
Release:        linux
Buildarch:      x86_64
Buildroot:      %{_topdir}/BUILDROOT/%{name}-%{version}-%{release}.%{buildarch}
License:        GPL v3
Group:          Applications/Graphics
URL:            https://github.com/eexpress/showit
Distribution:   Linux/x64
Packager:       eexpss<eexpss@gmail.com>
Prefix:         %{_prefix}

%description
Show SVG PNG TXT on screen. Use mouse and/or Meta Key to Zoom/Scale/Rotate/Change_Color/Change_Layer.

%pre
%build
%install
mkdir -p %{buildroot}/usr/bin/
mkdir -p %{buildroot}/usr/share/pixmaps/
mkdir -p %{buildroot}/usr/share/applications/
mkdir -p %{buildroot}/usr/share/nautilus/scripts/
mkdir -p %{buildroot}/usr/share/showit/
install -m 755 /home/eexpss/bin/showit/showit %{buildroot}/usr/bin/showit
install -m 755 /home/eexpss/bin/showit/showsvgpngtxt %{buildroot}/usr/bin/showsvgpngtxt
install -m 755 /home/eexpss/bin/showit/showit.png %{buildroot}/usr/share/pixmaps/showit.png
install -m 755 /home/eexpss/bin/showit/showit.desktop %{buildroot}/usr/share/applications/showit.desktop
install -m 755 /home/eexpss/bin/showit/showsvgpngtxt.desktop %{buildroot}/usr/share/applications/showsvgpngtxt.desktop
install -m 755 /home/eexpss/bin/showit/显示SVG-PNG到桌面.pl %{buildroot}/usr/share/nautilus/scripts/显示SVG-PNG到桌面.pl
install -m 755 /home/eexpss/bin/showit/svg/*.svg %{buildroot}/usr/share/showit/
%files
%defattr(-,root,root)
/usr/bin/showit
/usr/bin/showsvgpngtxt
/usr/share/pixmaps/showit.png
/usr/share/applications/showit.desktop
/usr/share/applications/showsvgpngtxt.desktop
/usr/share/nautilus/scripts/显示SVG-PNG到桌面.pl

/usr/share/showit/arrow.svg
/usr/share/showit/arrow-bend.svg
/usr/share/showit/frame.svg
/usr/share/showit/frame-hand.svg
/usr/share/showit/line.svg
/usr/share/showit/line-dash.svg
/usr/share/showit/mosaic.svg
/usr/share/showit/mosaic-grey.svg
/usr/share/showit/switch-app0.svg
/usr/share/showit/switch-Emoticon.svg
/usr/share/showit/switch-Flag.svg
/usr/share/showit/switch-frame.svg
/usr/share/showit/switch-Line.svg
/usr/share/showit/switch-Number.svg
/usr/share/showit/switch-OS.svg
/usr/share/showit/switch-penguin.svg
/usr/share/showit/switch-yesno.svg

