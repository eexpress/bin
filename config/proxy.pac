var darr = [
'google', 'gstatic', 'google-analytics', 'googleapis',
'googleusercontent', 'googlecode.com', 'youtube', 'chrome.com',
'gmail', 'sstatic.net', 'github', 'googlevideo.com',
'twitter', 'twimg', 'doubleclick.net', 'cyanogenmod', 'ytimg',
	'tumblr.com', 'recaptcha.net',
'ingress', 'appspot.com', 'telegram.org', 'reddit.com', 'webupd8.org',
'pastebin.com', 'disqus.com', 'launchpad.net',
'blogblog', 'blogger', 'wordpress', 'blogspot', 'feedburner.com',
'instagram', 'facebook', 'opera', 'wikipedia', 'sf.net',
'sourceforge.net', 'stackoverflow.com', 'xda-developers.com',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl', 'j.mp', 'youtu.be',
'linuxtoy.org', 'askubuntu.com', 'amazonaws.com', 'tumblr.com', 
'feedburner.com', 'kat.cr', 'tineye.com', 'jav4you.com',
	'zff.co', 'gnome-look.org',
'doubleclick.net', 'linuxquestions.org', 'omgubuntu.co.uk',
'inoreader.com', 'chromium.org',
];
/*
'faqoverflow.com', 'systhread.net', 'gravatar.com',
'pasteasy', 'ggpht', 'ubuntubuzz.com', 'anitalink.com',
'exceptionfound.com', 'pubzi.com', 'insynchq.com','etkey.org',
'publicbt.com', 'demonii.com', 'airvpn.org',
'getlantern.org','igfw.cc', 'openra.net', 'ubuntumaniac', 'damplips.com',
'noobslab.com','btdigg.org', 'dropbox.com', 'dropboxusercontent.com',
'torrentsmd.com', 'opensharing.org',
*/

function FindProxyForURL(url, host){
	var autosocks = 'SOCKS5 localhost:1080';
	for(var i=0;i<darr.length;i++){
		var append = '.*';
		if(darr[i].indexOf('.') != -1){ append = '/*'; }
		var str0 = '*.' + darr[i] + append;
		var str1 = '*://' + darr[i] + append;
		if(shExpMatch(url,str0) || shExpMatch(url,str1))
			return autosocks;
	}
	return "DIRECT";
}
