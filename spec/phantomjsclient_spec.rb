require 'lib/phantom_client/phantom_client_connection'
require 'lib/phantom_client/phantom_client'

require 'DummyConnection'
describe PhantomJSProxy::PhantomJSClient do
	before do
		@client = PhantomJSProxy::PhantomJSClient.new([{:addr => "127.0.0.1", :port => 5000}], nil, DummyConnection.new)
	end
	
	it "should have proxy config" do
		@client.getProxy().should == {:addr => "127.0.0.1", :port => 5000}
	end
	
	it "should return nothing without server" do
			@client.get("http://foo.de/").should == nil
	end
	
	describe "get fail" do
		before do
			@client = PhantomJSProxy::PhantomJSClient.new([{:addr => "127.0.0.1", :port => 5000}])
		end
		
		it "should return -Could not connect to proxy- without proxy connection" do
			@client.get("http://gamestar.de/").should == "Could not connect to proxy"
		end
	end
end
