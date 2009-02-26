# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform  = Gem::Platform::RUBY
  s.name      = "sprite_generator"
  s.summary   = "Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid."
  s.version   = "0.1.1"
  s.date      = Date.today.strftime('%Y-%m-%d')
  s.author    = "Marcel Scherf"
  s.email     = "marcel.scherf@gmail.com"
  s.homepage  = "http://www.marcelscherf.com"
  
  s.files     = [ "README.textile", "lib/sprite_generator.rb", "lib/sprite_batch_generator.rb" ]
  
  s.add_dependencies("liquid", ">= 1.7.0")
  s.add_dependencies("rmagick", ">= 2.2.2")
  
  s.require_path = "lib"
end
