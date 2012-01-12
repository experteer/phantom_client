require 'rubygems'

task :build do
	sh "gem build phclient.gemspec"
end

task :install do
	sh "gem install phantom_client-*.gem"
end

task :uninstall do
	sh "gem uninstall phantom_client"
end

task :clean do
	sh "rm phantom_client-*.gem"
end
