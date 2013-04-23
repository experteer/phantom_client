require 'net/http'
require 'uri'
require 'hmac-md5'
require "base64"

module PhantomJSProxy
  class DummyResponse
    attr_accessor :body
    attr_accessor :code
  end
  class DummyLogger
    def info msg
      puts msg
    end
    
    def warn msg
      puts msg
    end
    
    def error msg
      purs msg
    end
  end

	class PhantomJSClient
	
		attr_accessor :proxy_addr
		attr_accessor :proxy_port
		attr_accessor :proxy_list
		attr_accessor :connection
    attr_accessor :hmac
    attr_accessor :hmac_activated
    attr_accessor :logger
		
		def initialize(addr_list=[], key=nil, log=nil, con = PhantomJSClientConnection.new)
			@proxy_list = addr_list
			@connection = con
			@hmac_activated = key ? true : false
			@hmac = HMAC::MD5.new key
			@logger = log
			if @logger == nil
			  @logger = DummyLogger.new
			end
			logger.info "Using #{key} as HMAC key"
		end
		
		def get_body(addr, options=nil)
		  get(addr, options).body
		end
		
		def get(addr_in, options=nil)		
			addr,url, req = generate_request(addr_in)
			
			if options && options['imageOnly']
				req['Get-Page-As-Image'] = options['imageOnly']
				logger.info "Do image only"
			end
			
			if options && options['withIframes']
				req['Get-Page-With-IFrames'] = options['withIframes']
				logger.info "Do fetch iframes"
			end
			
			if hmac_activated
			  update_hmac_head addr, req, hmac
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
		
		private
		def update_hmac_head(addr, req, hmac_keygen)
		  t = Time.now
      req['Hmac-Key'] = hmac_keygen.update(addr+t.to_s).hexdigest
      req['Hmac-Time'] = t
      logger.info "Encode: #{addr} to #{req['Hmac-Key']}"
		end

		def generate_request(addr)
			begin	
				url = URI.parse(addr)
				req = Net::HTTP::Get.new(url.path)
				req['User-Agent'] = "PhantomJSClient"
				req.body = url.query
				return addr, url, req
			rescue URI::InvalidURIError
				#this now means we got a bad url
				addr_out = "http://phantomProxy.get/"
				url = URI.parse(addr_out)
				req = Net::HTTP::Get.new(url.path)
				req['User-Agent'] = "PhantomJSClient"
				req.body = "address="+Base64.encode64(addr)
				return addr_out, url, req
			end
		end

    def do_get(url, req, count)
        element = get_proxy()	
        if element[:addr] && element[:port]
          logger.info "try: "+element[:addr]+", "+element[:port]
        else
          logger.info "DUMMY TRY"
        end
        
        begin
          @connection.do_request(element, url, req)
        rescue Exception => e
          if count == 0
            raise NoProxy, "Could not reach any Proxy"
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
