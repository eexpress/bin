function FindProxyForURL(url, host)
{
	url = url.toLowerCase();
	host = host.toLowerCase();
	Gappproxy="PROXY localhost:8000";
//        sshCJB="PROXY localhost:8888";
	UB = "PROXY 218.16.119.187:8000";
	sock = "SOCKS5 localhost:7070";
//        if(shExpMatch(host, "*.blogspot.com*"))  return sshCJB;
	if(shExpMatch(host, "*.blogspot.com*"))  return sock;
	if(shExpMatch(host, "*.youtube.com*"))  return sock;
	if(shExpMatch(host, "*.onenot.com*"))  return Gappproxy;
	if(dnsDomainIs(host,"forum.ubuntu.org.cn")) return UB;
	else
//        return "DIRECT";
// ● 2011-07-15_23:19:51
// 对于所有的连接，先尝试直接连接，如果连不上，则使用localhost 7070端口的socks代理。参数url和host分别表示连接的完整URL和URL中的host name部分，可以据此为不同的地址配置不同的代理。
	return "DIRECT; sock";
}


