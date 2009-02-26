# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sprite_generator}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcel Scherf"]
  s.date = %q{2009-02-26}
  s.description = %q{}
  s.email = %q{marcel.scherf@gmail.com}
  s.extra_rdoc_files = ["Manifest.txt"]
  s.files = ["Manifest.txt", "README.textile", "lib/sprite_generator.rb", "lib/sprite_batch_generator.rb", "test/units/test_sprite_batch_generator.rb", "test/units/test_sprite_generator.rb"]
  s.has_rdoc = true
  s.homepage = %q{bla bla }
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sprite_generator}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid.}
  s.test_files = ["test/units/test_sprite_batch_generator.rb", "test/units/test_sprite_generator.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<liquid>, [">= 1.7.0"])
      s.add_runtime_dependency(%q<rmagick>, [">= 2.2.2"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<liquid>, [">= 1.7.0"])
      s.add_dependency(%q<rmagick>, [">= 2.2.2"])
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<liquid>, [">= 1.7.0"])
    s.add_dependency(%q<rmagick>, [">= 2.2.2"])
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end
