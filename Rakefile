ENV['RUBY_FLAGS'] = ''


require 'rubygems'
require 'hoe'
 require 'rcov/rcovtask'
require './lib/sprite_generator'

task 'gemspec' do |t|
  `rake -s debug_gem > sprite_generator.gemspec`
end

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --aggregate coverage.data --text-summary -Ilib"
    system("#{rcov} --html test/units/test_*.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end

Hoe.new "sprite_generator", SpriteGenerator::VERSION do |p|
  p.developer "the-architect", 'marcel.scherf@gmail.com'
  p.summary   = "Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid."
  
  p.author    = "Marcel Scherf"
  p.email     = "marcel.scherf@gmail.com"
  
  p.extra_deps << ["liquid"]
  p.extra_deps << ["rmagick"]
end