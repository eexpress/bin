function FindProxyForURL(url, host) {
	var autosocks = 'SOCKS5 127.0.0.1:1080';

	if (	shExpMatch(url,"*.google.*") ||
			shExpMatch(url,"*.gstatic.*") ||
			shExpMatch(url,"*.google-analytics.*") ||
			shExpMatch(url,"*.googleapis.*") ||
			shExpMatch(url,"*.googleusercontent.*") ||
			shExpMatch(url,"*.twitter.*") ||
			shExpMatch(url,"*.twimg.*") ||
			shExpMatch(url,"*.ingress.*") ||
			shExpMatch(url,"*.telegram.org") ||
			shExpMatch(url,"*.youtube.*") ||
			shExpMatch(url,"*.blogblog.*") ||
			shExpMatch(url,"*.blogger.*") ||
			shExpMatch(url,"*.wordpress.*") ||
			shExpMatch(url,"*.blogspot.*") ||
			shExpMatch(url,"*.cyanogenmod.*") ||
			shExpMatch(url,"*.github.*") ||
			shExpMatch(url,"*.ytimg.*") ||
			shExpMatch(url,"*.instagram.*") ||
			shExpMatch(url,"*.opera.*") ||
			shExpMatch(url,"*.wikipedia.*") ||
			shExpMatch(url,"*.sf.net") ||
			shExpMatch(url,"*.sourceforge.net") ||
			shExpMatch(url,"*.stackoverflow.com") ||
			shExpMatch(url,"*.xda-developers.com") ||
			shExpMatch(url,"*.linuxtoy.org") ||
			shExpMatch(url,"*.bit.ly") ||
			shExpMatch(url,"*.ift.tt") ||
			shExpMatch(url,"*.t.co") ||
			shExpMatch(url,"*.ow.ly") ||
			shExpMatch(url,"*.goo.gl") ||
			shExpMatch(url,"*.askubuntu.com") ||
			shExpMatch(url,"*.") ||
			shExpMatch(url,"*.facebook.*") 
			){ return autosocks; }

	if (
	dnsDomainIs(host, ".google.com") ||
	host == 'goo.gl') { return autosocks; }
	return "DIRECT";
}
