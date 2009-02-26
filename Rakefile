require 'rubygems'
require 'hoe'
require './lib/sprite_generator'

Hoe.new "sprite_generator", SpriteGenerator::VERSION do |p|
  p.developer "the-architect", 'marcel.scherf@gmail.com'
  p.summary   = "Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid."
  
  p.author    = "Marcel Scherf"
  p.email     = "marcel.scherf@gmail.com"
  
  p.extra_deps << ["liquid", ">= 1.7.0"]
  p.extra_deps << ["rmagick", ">= 2.2.2"]

end