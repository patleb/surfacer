$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "surface/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "surface-rb"
  s.version     = Surface::VERSION
  s.authors     = ["Patrice Lebel"]
  s.email       = ["patleb@users.noreply.github.com"]
  s.homepage    = "https://github.com/patleb/surface-rb"
  s.summary     = "Material Design, CSS only framework."
  s.description = "Material Design, CSS only framework."
  s.license     = "MIT"

  s.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "README.md"]
end
