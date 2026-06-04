require_relative "lib/fastbound/version"

Gem::Specification.new do |spec|
  spec.name    = "fastbound"
  spec.version = Fastbound::VERSION
  spec.authors = ["JD Warren"]
  spec.email = ["johndavid400@gmail.com"]
  spec.summary = "Ruby API wrapper for the FastBound firearms compliance API"
  spec.homepage = "https://github.com/johndavid400/fastbound"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.0", "< 3.0"
  spec.add_dependency "faraday-multipart", "~> 1.0"
end
