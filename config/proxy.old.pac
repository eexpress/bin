function FindProxyForURL(url, host) {
	var autosocks = 'SOCKS5 localhost:1080';

	if ( 0
		|| shExpMatch(url,"*.google.*")
		|| shExpMatch(url,"*.gstatic.*")
		|| shExpMatch(url,"*.google-analytics.*")
		|| shExpMatch(url,"*.googleapis.*")
		|| shExpMatch(url,"*.googleusercontent.*")
		|| shExpMatch(url,"*.twitter.*")
		|| shExpMatch(url,"*.twimg.*")
		|| shExpMatch(url,"*.ingress.*") || shExpMatch(url,"*.appspot.com")
		|| shExpMatch(url,"*.telegram.org")
		|| shExpMatch(url,"*.youtube.*")
		|| shExpMatch(url,"*.blogblog.*")
		|| shExpMatch(url,"*.blogger.*")
		|| shExpMatch(url,"*.wordpress.*")
		|| shExpMatch(url,"*.blogspot.*")
		|| shExpMatch(url,"*.cyanogenmod.*")
		|| shExpMatch(url,"*.github.*")
		|| shExpMatch(url,"*.ytimg.*")
		|| shExpMatch(url,"*.instagram.*")
		|| shExpMatch(url,"*.opera.*")
		|| shExpMatch(url,"*.wikipedia.*")
		|| shExpMatch(url,"*.sf.net")
		|| shExpMatch(url,"*.sourceforge.net")
		|| shExpMatch(url,"*.stackoverflow.com")
		|| shExpMatch(url,"*.xda-developers.com")
		|| shExpMatch(url,"*.linuxtoy.org")
		|| shExpMatch(url,"*.bit.ly")
		|| shExpMatch(url,"*.ift.tt")
		|| shExpMatch(url,"*.t.co")
		|| shExpMatch(url,"*.ow.ly")
		|| shExpMatch(url,"*.goo.gl")
		|| shExpMatch(url,"*.askubuntu.com")
		|| shExpMatch(url,"*.igfw.cc")
		|| shExpMatch(url,"*.facebook.*") 
			){ return autosocks; }

	return "DIRECT";
}
