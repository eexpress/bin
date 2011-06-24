function FindProxyForURL(url, host)
{
	url = url.toLowerCase();
	host = host.toLowerCase();
	Gappproxy="PROXY localhost:8000";
	sshCJB="PROXY localhost:8888";
	UB = "PROXY 218.16.119.187:8000";
//        if(shExpMatch(host, "*.blogspot.com*"))  return sshCJB;
	if(shExpMatch(host, "*.blogspot.com*"))  return Gappproxy;
	if(shExpMatch(host, "*.youtube.com*"))  return Gappproxy;
	if(shExpMatch(host, "*.onenot.com*"))  return Gappproxy;
	if(dnsDomainIs(host,"forum.ubuntu.org.cn")) return UB;
	else return "DIRECT";
}

