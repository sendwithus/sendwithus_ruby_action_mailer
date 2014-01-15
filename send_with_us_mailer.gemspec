# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'send_with_us_mailer/version'

Gem::Specification.new do |gem|
  gem.name          = "sendwithus_ruby_action_mailer"
  gem.version       = SendWithUsMailer::VERSION
  gem.authors       = ["David Lokhorst", "Nicholas Rempel"]
  gem.email         = ["nick@sendwithus.com"]
  gem.description   = %q{A convenient way to use the Send With Us email
    service with a Ruby on Rails app. SendWilthUsMailer implements a
    mailer API similar to the ActionMailer railtie.}
  gem.summary       = %q{An ActionMailer look alike for Send With Us.}
  gem.homepage      = 'http://github.com/nrempel/SendWithUs-Mailer'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'send_with_us'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest-colorize'
  gem.add_development_dependency 'mocha'
end
