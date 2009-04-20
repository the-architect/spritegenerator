require 'rubygems'
require 'RMagick'
require 'liquid'

class SpriteGenerator
  VERSION = '0.1.9'
  
  include Magick
    
  # parameters:
  # files_or_path: can be Dir.glob-able paths or an array of filenames 
  #   ie: ['../images/icons/icon1_out.png', '../images/icons/icon1_over.png'] or '../images/icons/icon*.png' 
  # output: filename where the generated sprite will be stored
  #   ie: '../images/sprites/icons.png'
  # options: set a variety of options
  #   - delimiter: characters by which multiple variations of images will be found
  #     ie: '_' for 'icon_hover.png'
  #     ie: '-' for 'icon-hover.png'
  #         if icon is the basename
  #   - sprite_location: will be available as variable in the liquid template, if this is not set, the template will use output as sprite_location
  #   - tile: if set to ie. '100x100' it will center every image on a 100 by 100 tile
  #   - template: Liquid template for each sprite, use this to build the css for your sprites
  #             these variables are available:
  #             - top: distance to top border of sprite in pixels 
  #             - left: distance to left border of sprite in pixels 
  #             - width: width of current image in pixels 
  #             - height: height of current image in pixels 
  #             - basename: filename or basename of variations
  #               ie: with variations: icon_out.png, icon_over.png  => icon
  #               ie: without variations: icon.png => icon.png
  #             - filename: icon_over.png
  #             - full_filename: ../images/icons/icon_over.ong
  #             - variations: number of variations as number
  #             - variation: the current variation as zero based number
  #             - sprite_location: path to sprite
  def initialize(files_or_paths, output, root, options = {})
    @files = find_files(files_or_paths)
    return if @files.nil? || @files.empty?
    @root       = root || ''
    @output     = output
    @delimiter  = options[:delimiter] || '-'
    @analyzed   = analyze_filenames(@files, @delimiter)
    @template   = Liquid::Template.parse(options[:template] || '')
    
    @sprite_location = options[:sprite_location] || @output
    @background = options[:background] || '#FFFFFF00'
    @tile_size  = options[:tile]
    @gravity    = options[:gravity] ? Magick.const_get("#{camelize(options[:gravity])}Gravity") : Magick::CenterGravity
  end
  
  
  def create
    raise 'No files found.' if @files.nil? || @files.empty?
    background = @background
    unless @tile_size.nil?
      size_x, size_y = @tile_size.split('x').first(2).map{|dim| dim.to_i}
      tile = Magick::Image.new(size_x, size_y){ self.background_color = background }
      tile.format = "PNG"
    end
    destination = @root.nil? || @root.empty? ? @output : File.join(@root, @output)
    image, css = build(tile)
    image.write(destination){ self.background_color = background }
    css
  end
  
  
protected
  
  # simplyfied version of active_supports camelize version
  def camelize(lower_case_and_underscored_word)
    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end
  
  def build(tile = nil)
    background = @background
    images = ImageList.new{ self.background_color = background }
    context = { 'sprite_location' => @sprite_location, 'tile' => tile }
    css = []
    
    @analyzed.each do |key, value|
      if tile
        context['left'] = images.length > 0 ? tile.columns : 0
      else
        context['left'] = images.length > 0 ? images.append(false).columns : 0
      end
      context['top'] = 0
      context['basename'] = key
      context['overall'] = images.length
      
      if value.size > 1
        image_list = ImageList.new(*value){ self.background_color = background }
        if tile
          tiles = ImageList.new{ self.background_color = background }
          image_list.each do |image|
            tiles << tile.composite(image, @gravity, Magick::OverCompositeOp)
          end
          images.from_blob(tiles.append(true).to_blob){ self.background_color = background }
        else
          images.from_blob(image_list.append(true).to_blob){ self.background_color = background }
        end
        context['variations'] = image_list.length
        context['type'] = :list
        context['images'] = image_list
        context['filenames'] = value
      else
        image = Image.read(value.flatten.first){ self.background_color = background }
        context['variations'] = 0
        context['variation_name'] = ''
        context['variation_number'] = 0
        context['type'] = :image
        
        if tile
          images.from_blob(tile.composite(image.first, @gravity, Magick::OverCompositeOp).to_blob){ self.background_color = background }
        else
          images.from_blob(image.first.to_blob){ self.background_color = background }
        end
      end
      css << build_css(context)
    end
    
    [images.append(false), css.join("\n")]
  end
  
  
  def build_css(context = {})
    type = context.delete('type')
    case type
    when :list
      css = build_css_for_list(context)
    when :image
      # render template if there is only one image
      css = @template.render(context)
    end
    css
  end
  
  
  def build_css_for_list(context)
    new_context = context.dup
    tile = new_context.delete('tile')
    image_list = context.delete('images')
    new_context['type'] = :image
    css = image_list.inject([]) do |css, image|
      new_context['width'] = tile ? tile.columns : image.columns
      new_context['height'] = tile ? tile.rows : image.rows
      new_context['variation_number'] = css.size
      
      new_context['full_filename'] = context['filenames'].shift
      new_context['filename'] = File.basename(new_context['full_filename'])
      new_context['file_basename'] = File.basename(new_context['full_filename'], '.*')
      new_context['variation_name'] = new_context['file_basename'].gsub(/^#{new_context['basename']}#{@delimiter}/, '')

      css << build_css(new_context.dup)
      new_context['top'] += tile ? tile.columns : new_context['height']
      css
    end.join("\n")
  end
  
  
  # gather files that will be used to create the sprite
  def find_files(*args)
    args.inject([]) do |files, arg|
      found_files = Dir.glob(arg)
      if found_files.empty?
        files << arg if File.exists?(arg) rescue raise arg.inspect
      else
        files << found_files.flatten
      end
      files.flatten.compact.uniq
    end
  end
  
  
  # gather information about the selected files
  # check for variations by using a delimiter as an indicator
  def analyze_filenames(file_names, delimiter = '_')
    file_names.inject(Hash.new{|hash, key| hash[key] = Array.new;}) do |h, file|
      basename = File.basename(file).split('.').first
      without_variation = basename.split(delimiter)[0..-2].join(delimiter)
      basename = without_variation.nil? || without_variation == '' ? basename : without_variation
      h[basename] << file
      h
    end
  end
  
  
end