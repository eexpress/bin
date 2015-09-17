function FindProxyForURL(url, host) {
	var autosocks = 'SOCKS5 127.0.0.1:1080';
//    var autosocks = 'SOCKS5 127.0.0.1:7070';
    if (host == '127.0.0.1' || isPlainHostName(host)) { return "DIRECT"; }
	if (	shExpMatch(url,"*google*") ||
			shExpMatch(url,"*twitter*") ||
			shExpMatch(url,"*blogspot*") ||
			shExpMatch(url,"*instagram*") ||
			shExpMatch(url,"*facebook*") ||
			){ return autosocks; }

	if (
	dnsDomainIs(host, ".mi.com") ||
	dnsDomainIs(host, ".xiaomi.net") ||
	dnsDomainIs(host, ".xiaomi.com") ||
	dnsDomainIs(host, ".0316366.com") ||
	dnsDomainIs(host, ".aitaotu.com") ||
	dnsDomainIs(host, ".taobao.com") ||
	dnsDomainIs(host, ".etao.com") ||
	dnsDomainIs(host, ".tmall.com") ||
	dnsDomainIs(host, ".gstatic.com") ||
	dnsDomainIs(host, ".twimg.com") ||
	dnsDomainIs(host, ".youtube.com") ||
	dnsDomainIs(host, ".cloudfront.net") ||
	dnsDomainIs(host, ".ingress.com") ||
	dnsDomainIs(host, ".blogblog.com") ||
	dnsDomainIs(host, ".blogger.com") ||
	dnsDomainIs(host, ".wordpress.com") ||
	dnsDomainIs(host, ".cyanogenmod.org") ||
	dnsDomainIs(host, ".mozilla.org") ||
	dnsDomainIs(host, ".telegram.org") ||
	dnsDomainIs(host, ".disqus.com") ||
	dnsDomainIs(host, ".disquscdn.com") ||
	dnsDomainIs(host, ".apkmirror.com") ||
	dnsDomainIs(host, ".github.io") ||
	dnsDomainIs(host, ".ytimg.com") ||
	dnsDomainIs(host, ".opera.com") ||
	dnsDomainIs(host, ".digicert.com") ||
	dnsDomainIs(host, ".wikipedia.org") ||
	dnsDomainIs(host, ".wikimedia.org") ||
	dnsDomainIs(host, ".sf.net") ||
	dnsDomainIs(host, ".sourceforge.net") ||
	dnsDomainIs(host, ".stackoverflow.com") ||
	dnsDomainIs(host, ".xda-developers.com") ||
	dnsDomainIs(host, ".sstatic.net") ||
	dnsDomainIs(host, ".linuxtoy.org") ||
	dnsDomainIs(host, ".feedburner.com") ||
	dnsDomainIs(host, ".jav4you.com") ||
	dnsDomainIs(host, ".dmm.co.jp") ||
	dnsDomainIs(host, ".bit.ly") ||
	dnsDomainIs(host, ".ift.tt") ||
	dnsDomainIs(host, ".t.co") ||
	dnsDomainIs(host, ".ow.ly") ||
	dnsDomainIs(host, ".goo.gl") ||
	dnsDomainIs(host, ".kickass.to") ||
	dnsDomainIs(host, ".kat.cr") ||
	dnsDomainIs(host, ".publicbt.com") ||
	dnsDomainIs(host, ".demonii.com") ||
	dnsDomainIs(host, ".nytimes.com") ||
	dnsDomainIs(host, ".akamaihd.net") ||
	dnsDomainIs(host, ".juesetuku.com") ||
	dnsDomainIs(host, ".askubuntu.com") ||
	dnsDomainIs(host, ".scorecardresearch.com") ||
	host == 'goo.gl') { return autosocks; }
	return "DIRECT";
}
