#!/usr/bin/env python

import gnomekeyring as gk
import sys

keyring = 'login'
keyItems = gk.list_item_ids_sync(keyring)

for keyItem in keyItems:
    key = gk.item_get_info_sync(keyring, keyItem)
    att = gk.item_get_attributes_sync(keyring, keyItem)
    if sys.argv[1] in key.get_display_name():
        print "--------: ", key.get_display_name(), "\nLogin: ", att['username_value'], "\tPassword: ", key.get_secret()

