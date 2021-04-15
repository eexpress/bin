dbus-monitor "
  type='signal',
  interface='org.freedesktop.DBus.Properties',
  path='/org/freedesktop/FileManager1',
  member='PropertiesChanged'" |
  awk -F '"' '
    $2 ~ "^/org/gnome/Nautilus/window/[[:digit:]]+$" {
      window = $2
      sub(".*/", "", window)
      tab = 0
      next
    }
    window && /string / {
      print window"."++tab": "$2
      next
    }
    tab {window = 0}'
