require 'rubygems'
require 'liquid'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/sprite_generator')

class SpriteGeneratorTest < Test::Unit::TestCase
  
  def setup
    @template = '.{{basename}}_{{variation}}{ background:transparent url({{sprite_location}}) -{{left}}px -{{top}}px no-repeat; width:{{width}}px; height:{{height}}px; }'
    @all_images_path = 'test/images/*.png'
    @output = 'test/output/sprite_by_create.png'
    @page_path = 'test/output/test.html'
  end
  
  
  def teardown
    # delete test output
    Dir.glob('test/output/*').each{|f| File.delete f }
  end
  
  
  def test_should_create_correct_context
    template = %q{
      basename: {{basename}}
      variation: {{variation}}
      sprite_location: {{sprite_location}}
      left: {{left}}
      top: {{top}}
      width: {{width}}
      height: {{height}}
      filename: {{filename}}
      file_basename: {{file_basename}}
      full_filename: {{full_filename}}
      variations: {{variations}}
      variation_number: {{variation_number}}
      variation_name: {{variation_name}}
    }
    @generator = SpriteGenerator.new(@all_images_path, @output, nil, {:template => template})
    css = @generator.create
    assert css.include?('basename: emoticon-evilgrin')
    assert css.include?('variation_name: evilgrin')
    assert css.include?('file_basename: emoticon-evilgrin')
  end
  
  
  def test_should_center_images_on_tiles
    @generator = SpriteGenerator.new(@all_images_path, @output, nil, {:template => @template, :tile => '100x100', :background => '#FFFFFF00'})
    css = @generator.create
    page = Liquid::Template.parse(File.open('test/templates/test.html').read).render('css' => css)
    assert page.include?("{ background:")
    assert page.include?("width:100px")
    assert page.include?("height:100px")
    assert page.include?("-300px")
    assert page.include?("-800px")
    File.open(@page_path, 'w+'){|f| f.puts page }
    assert File.exists?(@page_path)
  end
  
  
  def test_should_create_correct_css
    @generator = SpriteGenerator.new(@all_images_path, @output, nil, :template => @template)
    css = @generator.create()
    page = Liquid::Template.parse(File.open('test/templates/test.html').read).render('css' => css)
    assert page.include?("{ background:")
    assert page.include?("width:16px")
    assert page.include?("height:16px")
    assert page.include?("-16px")
    assert page.include?("-96px")
    File.open(@page_path, 'w+'){|f| f.puts page }
    assert File.exists?(@page_path)
  end
  
  
  def test_should_generate_sprite_file
    @generator = SpriteGenerator.new(@all_images_path, @output, nil, :template => @template)
    css = @generator.create
    assert !(css.nil? || css.empty?)
    assert File.exists?(@output)
  end
  
  
  def test_should_find_versions_of_emoticons
    files = Dir.glob(@all_images_path)
    @generator = SpriteGenerator.new(files, @output, nil, {})
    analyzed = @generator.instance_variable_get(:@analyzed)
    assert_equal 9, analyzed['emoticon'].size
  end
  
  
  def test_should_find_files_for_glob_path
    @generator = SpriteGenerator.new(@all_images_path, @output, nil, {})
    files = @generator.instance_variable_get(:@files)
    assert_equal 16, files.size
  end
  
  
  def test_should_find_files
    @generator = SpriteGenerator.new(['test/images/emoticon-evilgrin.png', 'test/images/emoticon-grin.png'], @output, nil, {})
    files = @generator.instance_variable_get(:@files)
    assert_equal 2, files.size
  end
  
  
  def test_should_not_find_anything
    @generator = SpriteGenerator.new('test/blalala/*.hurz', @output, nil, {})
    files = @generator.instance_variable_get(:@files)
    assert_equal 0, files.size
  end
  
  
end