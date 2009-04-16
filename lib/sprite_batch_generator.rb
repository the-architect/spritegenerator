require 'yaml'
require 'ostruct'
require 'pathname'
require File.expand_path(File.dirname(__FILE__) + '/sprite_generator')

class SpriteBatchGenerator
  attr_reader :batches
  
  def initialize(filename)
    config = YAML.load(File.read(filename))
    @batches = config.inject([]) do |arr, pair|
      if !!defined?(RAILS_ROOT)
        pair.last.merge!(:config_root => RAILS_ROOT)
      elsif pair.last[:root]
        root = File.expand_path(pair.last[:root], file_name)
        pair.last.merge!(:config_root => root)
      end
      arr.push OpenStruct.new(pair.last)
      arr
    end
  end
  
  
  def generate
    @batches.each do |batch|
      generator = SpriteGenerator.new(batch.files, batch.output, batch.config_root, batch.options || {})
      css       = generator.create
      # only write output if css_output is specified
      unless css.nil? || css.empty? || batch.css_output.nil?
        output = batch.css_template.nil? ? css : Liquid::Template.parse(File.open(batch.css_template).read).render('css' => css)
        File.open(batch.css_output, 'w+'){|f| f.puts output }
      end
    end
  end
  
  
end