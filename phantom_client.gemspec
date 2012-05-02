require 'rubygems'
require 'rake'

Gem::Specification.new do |s|
  s.name        = 'phantom_client'
  s.version     = '1.1.0'
  s.summary     = "This is a phantomjs Proxy client"
  s.description = "This is a phantomjs Proxy client"
  s.authors     = ["Daniel Sudmann"]
  s.email       = 'suddani@googlemail.com'
  s.files       = FileList['lib/**/*.rb',
                      'bin/*',
                      '[A-Z]*',
                      'test/**/*'].to_a
  s.homepage    = 'http://experteer.com'
  s.executables = ['phantom_client']
  s.add_dependency('ruby-hmac', '>= 0.4.0')
end
