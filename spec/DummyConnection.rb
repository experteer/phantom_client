class DummyConnection < PhantomJSProxy::PhantomJSClientConnection
	def doRequest(proxy, uri, req)
	end
end
