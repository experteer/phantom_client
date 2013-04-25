require 'net/http'
require 'uri'

module PhantomJSProxy
	class PhantomJSClientConnection
		def do_request(proxy, url, req)
				conn = Net::HTTP::Proxy(proxy[:addr], proxy[:port]).new(url.host, url.port)
				conn.read_timeout = 180
				res = conn.start() {|http|
					http.request(req)
				}
				return res
		end
	end
end
