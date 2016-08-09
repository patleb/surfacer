$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "surfacer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "surfacer"
  s.version     = Surfacer::VERSION
  s.authors     = ["Patrice Lebel"]
  s.email       = ["patleb@users.noreply.github.com"]
  s.homepage    = "https://github.com/patleb/surfacer"
  s.summary     = "Material Design, CSS only framework."
  s.description = "Material Design, CSS only framework."
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "viewizer", "~> 0.1"
  s.add_dependency "material_icons", "~> 2.2"
end
