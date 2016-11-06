# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ever_mid"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY

  s.authors     = ["ken"]
  s.email       = ["block24block@gmail.com"]
  s.homepage    = "https://github.com/turnon/ever_mid"
  s.summary     = 'preprocess evernote-exported htmls, make them recognized by middleman builder'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 4.1.10"])
  
  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
end
