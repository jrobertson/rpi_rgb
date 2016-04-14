Gem::Specification.new do |s|
  s.name = 'rpi_rgb'
  s.version = '0.1.3'
  s.summary = 'Changes the colour of an RGB LED connected via GPIO to a Raspberry Pi '
  s.authors = ['James Robertson']
  s.files = Dir['lib/rpi_rgb.rb']
  s.add_runtime_dependency('rpi_led', '~> 0.1', '>=0.1.2') 
  s.signing_key = '../privatekeys/rpi_rgb.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rpi_rgb'
end
