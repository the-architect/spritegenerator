require File.expand_path('../../test_helper', __FILE__)

class GeneratorTest < Test::Unit::TestCase

  def setup
    @template = '.{{basename}}_{{variation}}{ background:transparent url({{sprite_location}}) -{{left}}px -{{top}}px no-repeat; width:{{width}}px; height:{{height}}px; }'
    @all_images_path = File.join(Sprites::Config.root, 'test', 'images', '*.png')
    @output = File.join(Sprites::Config.root, 'test', 'output', 'sprite_by_create.png')
    @page_path = File.join(Sprites::Config.root, 'test', 'output', 'test.html')
  end
  
  def teardown
    # delete test output
    Dir.glob(File.join(Sprites::Config.root, 'test', 'output', '*')).each{|f| File.delete f }
  end

  should "create correct sprite for tile with vertical distribution" do
    options = {
      :distribution => 'vertical',
      :tile         => '40x300',
      :alignment    => 'north_west',
      :template     => "a.{{file_basename}} { padding-left:2em; background: transparent url(#{this_method}.png) -{{left}}px -{{top}}px no-repeat; }"
    }
    
    generator = Sprites::Generator.new(@all_images_path, "test/output/#{this_method}.png", nil, options)
    css = generator.create
    assert css.include?('-4500px')
    
    page = Liquid::Template.parse(File.open('test/templates/link.html').read).render('css' => css, 'image' => "#{this_method}.png")
    output_file = File.join('test', 'output', "#{this_method}.html")
    File.open(output_file, 'w+'){ |f| f.puts page }
    assert File.exists?(output_file)
  end  
  
  should "create correct sprite for tile with horizontal distribution" do
    options = {
      :distribution => 'horizontal',
      :tile         => '400x50',
      :alignment    => 'north_west',
      :template     => "a.{{file_basename}} { padding-left:2em; background: transparent url(#{this_method}.png) -{{left}}px -{{top}}px no-repeat; }"
    }
    
    generator = Sprites::Generator.new(@all_images_path, "test/output/#{this_method}.png", nil, options)
    css = generator.create
    assert css.include?('-6000px')
    
    page = Liquid::Template.parse(File.open('test/templates/link.html').read).render('css' => css, 'image' => "#{this_method}.png")
    output_file = File.join('test', 'output', "#{this_method}.html")
    File.open(output_file, 'w+'){ |f| f.puts page }
    assert File.exists?(output_file)
  end
  
  
  should "use horizontal distribution" do
    template = %q{ {{left}} }
    generator = Sprites::Generator.new(@all_images_path, @output, nil, { :template => template, :distribution => 'horizontal' })
    css = generator.create
    assert css.include?('240')
  end
  
  should "use vertical distribution" do
    template = %q{ {{top}} }
    generator = Sprites::Generator.new(@all_images_path, @output, nil, { :template => template, :distribution => 'vertical' })
    css = generator.create
    assert css.include?('240')
  end
  
  should "set correct context filebasename for images without variations" do
    template = %q{ {{file_basename}} }
    generator = Sprites::Generator.new(@all_images_path, @output, nil, { :template => template, :delimiter => '_' })
    css = generator.create
    assert css.include?('emoticon-evilgrin')
  end
  
  should "set correct context width for images without variations" do
    template = %q{ {{width}} }
    generator = Sprites::Generator.new(@all_images_path, @output, nil, { :template => template, :delimiter => '_' })
    css = generator.create
    assert css.include?('16')
  end
  
  should "set correct context top for images without variations" do
    template = %q{ {{top}} }
    generator = Sprites::Generator.new(@all_images_path, @output, nil, { :template => template, :delimiter => '_' })
    css = generator.create
    assert !css.include?('-16')
  end
  
  should "create correct context" do
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
    generator = Sprites::Generator.new(@all_images_path, @output, nil, {:template => template})
    css = generator.create
    assert css.include?('basename: emoticon-evilgrin')
    assert css.include?('variation_name: evilgrin')
    assert css.include?('file_basename: emoticon-evilgrin')
  end
  
  should "use alignment option" do
    assert_nothing_raised do
      Sprites::Generator.new(@all_images_path, @output, nil, {:template => @template, :tile => '100x100', :background => '#FFFFFF', :alignment => 'west'})
    end
  end
  
  should "complain about unknown alignment option" do
    assert_raise NameError do
      Sprites::Generator.new(@all_images_path, @output, nil, {:template => @template, :tile => '100x100', :background => '#FFFFFF', :alignment => 'somewhere'})
    end
  end
  
  should "center images on tiles" do
    @generator = Sprites::Generator.new(@all_images_path, @output, nil, {:template => @template, :tile => '100x100', :background => '#FFFFFF00'})
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
  
  
  should "create correct css" do
    @generator = Sprites::Generator.new(@all_images_path, @output, nil, :template => @template)
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
  
  
  should "generate sprite file" do
    @generator = Sprites::Generator.new(@all_images_path, @output, nil, :template => @template)
    css = @generator.create
    assert !(css.nil? || css.empty?)
    assert File.exists?(@output)
  end
  
  # bad, testing internal state
  should "find versions of emoticons" do
    files = Dir.glob(@all_images_path)
    @generator = Sprites::Generator.new(files, @output, nil, {})
    analyzed = @generator.instance_variable_get(:@analyzed)
    assert_equal 9, analyzed['emoticon'].size
  end
  
  # bad, using internal state
  should "find files for glob path" do
    @generator = Sprites::Generator.new(@all_images_path, @output, nil, {})
    files = @generator.instance_variable_get(:@files)
    assert_equal 16, files.size
  end
  
  # bad, using internal state
  should "find files" do
    @generator = Sprites::Generator.new(['test/images/emoticon-evilgrin.png', 'test/images/emoticon-grin.png'], @output, nil, {})
    files = @generator.instance_variable_get(:@files)
    assert_equal 2, files.size
  end
  
  # bad, using internal state
  should "not find anything" do
    @generator = Sprites::Generator.new('test/blalala/*.hurz', @output, nil, {})
    files = @generator.instance_variable_get(:@files)
    assert_equal 0, files.size
  end

protected
  # output filename based on test name for inspection
  def this_method
    caller[0] =~ /`([^']*)'/ and $1
  end

end