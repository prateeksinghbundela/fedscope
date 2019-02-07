
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fedscope/version"

Gem::Specification.new do |spec|
  spec.name          = "fedscope"
  spec.version       = Fedscope::VERSION
  spec.authors       = ["Prateek"]
  spec.email         = ["prateekyuvasoft101@gmail.com"]

  spec.summary       = %q{test rake}
  spec.description   = %q{test rake}
  spec.homepage      = "https://github.com/prateeksinghbundela/fedscope"
  spec.license       = "MIT"

  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_development_dependency "bundler", "~> 1.17"
  # spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "zip-zip"

end
