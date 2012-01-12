require 'rake'

Gem::Specification.new do |s|
  s.name        = 'phantom_client'
  s.version     = '1.0.0'
  s.summary     = "This is a phyntonjs Proxy client"
  s.description = "This is a phyntonjs Proxy client"
  s.authors     = ["Daniel Sudmann"]
  s.email       = 'suddani@googlemail.com'
  s.files       = FileList['lib/*.rb'].to_a
  s.homepage    = 'http://experteer.com'
end
