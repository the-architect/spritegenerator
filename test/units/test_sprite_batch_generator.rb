require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/sprite_batch_generator')

class SpriteBatchGeneratorTest < Test::Unit::TestCase

  def setup
    @config = 'test/config/batch.yml'
  end
  
  def teardown
    # delete test output
    Dir.glob('test/output/*').each{|f| File.delete f }
  end
  
  def test_should_read_config_file
    @batch = SpriteBatchGenerator.new(@config)
    assert_not_nil @batch
    assert_equal 2, @batch.batches.size
  end
  
  def test_should_create_files_from_config
    @batch = SpriteBatchGenerator.new(@config)
    css = @batch.generate
    assert_not_nil css
    output_files = Dir.glob('test/output/*')
    assert 6, output_files.size
  end
  
protected

  def this_method
    caller[0] =~ /`([^']*)'/ and $1
  end
  
end