require 'rubygems'
require 'liquid'
require 'test/unit'
require '../../sprite_generator.rb'

class SpriteGeneratorTest < Test::Unit::TestCase
  
  
  def setup
    @template = '.{{basename}}_{{variation}}{ background:transparent url({{sprite_location}}) -{{left}}px -{{top}}px no-repeat; width:{{width}}px; height:{{height}}px; }'
    @all_images_path = '../images/*.png'
  end
  
  
  def teardown
    # delete test output
    # Dir.glob('../output/*').each{|f| File.delete f }
  end
  
  
  def test_should_center_images_on_tiles
    output = '../output/sprite_by_create.png'
    page_path = '../output/test.html'
    css = SpriteGenerator.create(@all_images_path, output, {:template => @template, :tile => '100x100', :background => '#FFFFFF00'})
    page = Liquid::Template.parse(File.open('../templates/test.html').read).render('css' => css)
    assert page.include?("{ background:")
    assert page.include?("width:100px")
    assert page.include?("height:100px")
    assert page.include?("-300px")
    assert page.include?("-800px")
    File.open(page_path, 'w+'){|f| f.puts page }
    assert File.exists?(page_path)
  end
  
  def test_should_create_correct_css
    output = '../output/sprite_by_create.png'
    page_path = '../output/test.html'
    css = SpriteGenerator.create(@all_images_path, output, :template => @template)
    page = Liquid::Template.parse(File.open('../templates/test.html').read).render('css' => css)
    assert page.include?("{ background:")
    assert page.include?("width:16px")
    assert page.include?("height:16px")
    assert page.include?("-16px")
    assert page.include?("-96px")
    File.open(page_path, 'w+'){|f| f.puts page }
    assert File.exists?(page_path)
  end
  
  
  def test_should_generate_sprite_file
    output = '../output/sprite_by_create.png'
    css = SpriteGenerator.create(@all_images_path, output, :template => @template)
    assert !(css.nil? || css.empty?)
    assert File.exists?(output)
  end
  

  def test_should_find_versions_with_delimiter
    file_names = %w{bla.png blubb-over.png blubb-out.png bla_blubb-bla.png bla_blubb-hu.png}
    analyzed = SpriteGenerator.analyze_filenames(file_names, '-')
    assert_equal 3, analyzed.keys.size
    assert_equal 2, analyzed['blubb'].size
    assert_equal 2, analyzed['bla_blubb'].size
    assert_equal 'blubb-over.png', analyzed['blubb'].first
  end
  
  
  def test_should_find_versions_with_default_delimiter
    file_names = %w{bla.png blubb_over.png blubb_out.png bla_blubb_bla.png bla_blubb_hu.png}
    analyzed = SpriteGenerator.analyze_filenames(file_names)
    assert_equal 3, analyzed.keys.size
    assert_equal 2, analyzed['blubb'].size
    assert_equal 2, analyzed['bla_blubb'].size
    assert_equal 'blubb_over.png', analyzed['blubb'].first
  end
  

  def test_should_find_versions_of_emoticons
    files = Dir.glob(@all_images_path)
    analyzed = SpriteGenerator.analyze_filenames(files)
    assert_equal 9, analyzed['emoticon'].size
  end
  
  
  def test_should_find_files_for_glob_path
    files = SpriteGenerator.find_files(@all_images_path)
    assert_equal 16, files.size
  end
  
  
  def test_should_find_files
    files = SpriteGenerator.find_files('../images/emoticon_evilgrin.png', '../images/emoticon_grin.png')
    assert_equal 2, files.size
  end
  
  
  def test_should_not_find_anything
    files = SpriteGenerator.find_files('../blalala/*.hurz')
    assert_equal 0, files.size
  end
  
  
end