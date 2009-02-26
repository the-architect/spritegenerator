# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sprite_generator}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcel Scherf"]
  s.date = %q{2009-02-26}
  s.email = %q{marcel.scherf@gmail.com}
  s.homepage = %q{http://www.marcelscherf.com}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sprite_generator}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
