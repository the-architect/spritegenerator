# no warnings
ENV['RUBY_FLAGS'] = ''

require 'rubygems'
require './lib/sprite_generator'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |p|
    p.name      = 'sprite_generator'
    p.summary   = "Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid."
    p.author    = "Marcel Scherf"
    p.email     = "marcel.scherf@gmail.com"
    p.homepage  = "http://github.com/the-architect/spritegenerator"
    

    p.files = FileList['lib/**/*.rb']
    p.rubygems_version = '1.2.0'
    p.add_dependency('liquid')
    p.add_dependency('rmagick')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

  
