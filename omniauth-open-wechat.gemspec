# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |spec|
  spec.name          = "omniauth-open-wechat"
  spec.version       = version
  spec.authors       = ["yafeilee"]
  spec.email         = ["lyfi2003@gmail.com"]

  spec.summary       = %q{Omniauth strategy for open wechat}
  spec.description   = %q{OAuth2 to authenticate wechat user in web system( not in wechat )}
  spec.homepage      = "https://github.com/windy/omniauth-open-wechat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "byebug"
end
