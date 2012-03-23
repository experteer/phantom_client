class DummyConnection < PhantomJSProxy::PhantomJSClientConnection
	def do_request(proxy, uri, req)
	end
end
