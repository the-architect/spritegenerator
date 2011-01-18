require File.expand_path('../../test_helper', __FILE__)

class BatchTest < Test::Unit::TestCase

  def setup
    @config = File.join(Sprites::Config.root, 'test', 'config', 'batch.yml')
  end
  
  def teardown
    # delete test output
    Dir.glob('test/output/*').each{|f| File.delete f }
  end
  
  should "read config file" do
    @batch = Sprites::Batch.new(@config)
    assert_not_nil @batch
    assert_equal 2, @batch.batches.size
  end
  
  should "create files from config" do
    @batch = Sprites::Batch.new(@config)
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