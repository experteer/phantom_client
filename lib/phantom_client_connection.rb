require 'net/http'
require 'uri'

module PhantomJSProxy
	class PhantomJSClientConnection
		def doRequest(proxy, uri, req)
				res = Net::HTTP::Proxy(proxy[:addr], proxy[:port]).start(url.host, url.port) {|http|
					http.request(req)
				}
				return res.body
		end
	end
end
