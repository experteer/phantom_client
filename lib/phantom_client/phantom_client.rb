require 'net/http'
require 'uri'
require 'hmac-md5'

module PhantomJSProxy
  class DummyResponse
    attr_accessor :body
    attr_accessor :code
  end
	class PhantomJSClient
	
		attr_accessor :proxy_addr
		attr_accessor :proxy_port
		attr_accessor :proxy_list
		attr_accessor :connection
    attr_accessor :hmac
    attr_accessor :hmac_activated
		
		def initialize(addr_list=[], con = PhantomJSClientConnection.new, key=nil)
			@proxy_list = addr_list
			@connection = con
			@hmac_activated = key ? true : false
			@hmac = HMAC::MD5.new key
			puts "Using #{key} as HMAC key"
		end
		
		def get_body(addr, options=nil)
		  get(addr, options).body
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
				req['Get-Page-With-IFrames'] = options['withIframes']
				puts "Do fetch iframes"
			end
			
			if hmac_activated
			  t = Time.now+121
			  req['Hmac-Key'] = hmac.update(addr+t.to_s).hexdigest
			  req['Hmac-Time'] = t
        puts "Encode: #{addr} to #{req['Hmac-Key']}"
			end
			#::Proxy(@proxy_addr, @proxy_port)
			
			#element = get_proxy()	
			#begin
			#	@connection.do_request(element, url, req)
			#rescue
			#	return "Could not connect to proxy"
			#end
      do_get(url, req, 10)
		end
    
    def do_get(url, req, count)
        element = get_proxy()	
        if element[:addr] && element[:port]
          puts "try: "+element[:addr]+", "+element[:port]
        else
          puts "DUMMY TRY"
        end
        
        begin
          @connection.do_request(element, url, req)
        rescue
          if count == 0
            resp = DummyResponse.new()
            resp.code = 500
            resp.body ="Could not connect to proxy"
            return resp
          end
          do_get(url, req, count-1)
        end
    end
		
		def get_proxy
			element_n = rand(@proxy_list.count)
			if @proxy_list.count > 0
				return @proxy_list[element_n]
			end
			return {:addr => nil, :port => nil}
		end		
	end
end
