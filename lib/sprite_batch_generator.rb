require 'yaml'
require 'ostruct'
require File.expand_path(File.dirname(__FILE__) + '/sprite_generator')

class SpriteBatchGenerator
  attr_reader :batches
  
  def initialize(filename)
    config = YAML.load(File.read(filename))
    @batches = config.inject([]) do |arr, pair|
      arr.push OpenStruct.new(pair.last)
      arr
    end
  end
  
  def generate
    @batches.each do |batch|
      generator = SpriteGenerator.new(batch.files, batch.output, batch.options || {})
      css       = generator.create
      # only write output if css_output is specified
      unless css.nil? || css.empty? || batch.css_output.nil?
        if batch.css_template.nil?
          output = css
        else
          output  = Liquid::Template.parse(File.open(batch.css_template).read).render('css' => css)
        end
        File.open(batch.css_output, 'w+'){|f| f.puts output }
      end
    end
  end
  
end