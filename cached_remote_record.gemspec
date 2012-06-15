$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cached_remote_record/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cached_remote_record"
  s.version     = CachedRemoteRecord::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of CachedRemoteRecord."
  s.description = "TODO: Description of CachedRemoteRecord."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"

  s.add_development_dependency "sqlite3"
end
