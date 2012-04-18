require 'net/http'
require 'uri'

module PhantomJSProxy
	class PhantomJSClientConnection
		def do_request(proxy, url, req)
				res = Net::HTTP::Proxy(proxy[:addr], proxy[:port]).start(url.host, url.port) {|http|
					http.request(req)
				}
				return res
		end
	end
end
