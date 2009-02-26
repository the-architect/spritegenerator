require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'sprite_generator'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'sprite_batch_generator'))

class SpriteBatchGeneratorTest < Test::Unit::TestCase

  def setup
    @config = '../config/batch.yml'
  end
  
  
  def teardown
    # delete test output
    Dir.glob('../output/*').each{|f| File.delete f }
  end
  
  
  def test_should_read_config_file
    @batch = SpriteBatchGenerator.new(@config)
    assert_not_nil @batch
    assert_equal 2, @batch.batches.size
  end

  def test_should_create_files_from_config
    @batch = SpriteBatchGenerator.new(@config)
    @batch.generate
    output_files = Dir.glob('../output/*')
    assert 6, output_files.size
  end
  
end