require 'net/http'
require 'uri'
require 'phantom_client_connection'

module PhantomJSProxy
	class PhantomJSClient
	
		attr_accessor :proxy_addr
		attr_accessor :proxy_port
		attr_accessor :proxy_list
		attr_accessor :connection
		
		def initialize(addr_list=[], con = PhantomJSClientConnection.new)
			@proxy_list = addr_list
			@connection = con
		end
		
		def get(addr, options=nil)			
			url = URI.parse(addr)
			req = Net::HTTP::Get.new(url.path)
			req['User-Agent'] = "PhantomJSClient"
			if /\?/.match(addr)
				req.body = addr.split('?')[1]
			end
			
			if options && options['imageOnly']
				req['Get-Page-As-Image'] = options['imageOnly']
				puts "Do image only"
			end
			
			if options && options['withIframes']
				req['HTTP_GET_PAGE_WITH_IFRAMES'] = options['withIframes']
				puts "Do fetch iframes"
			end
			#::Proxy(@proxy_addr, @proxy_port)
			
			element = getProxy()	
			begin
				@connection.doRequest(element, url, req)
			rescue
				return "Could not connect to proxy"
			end
		end
		
		def getProxy
			element_n = rand(@proxy_list.count)
			if @proxy_list.count > 0
				return @proxy_list[element_n]
			end
			return {:addr => nil, :port => nil}
		end		
	end
end
