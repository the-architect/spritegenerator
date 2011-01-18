# no warnings
ENV['RUBY_FLAGS'] = ''
require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => [:test]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |p|
    p.name      = 'sprite_generator'
    p.summary   = "Automatically generate Sprite Images and the corresponding CSS using RMagick and Liquid."
    p.author    = "Marcel Scherf"
    p.email     = "marcel.scherf@gmail.com"
    p.homepage  = "http://github.com/the-architect/spritegenerator"
    
    p.description = "Automatically generate Sprite Images and the corresponding CSS."
    p.files = FileList['lib/**/*.rb']
    p.rubygems_version = '1.3.7'
    p.add_dependency('liquid')
    p.add_dependency('rmagick')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

  
