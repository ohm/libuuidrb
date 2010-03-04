require 'rubygems'
require 'test/unit'

begin
  require File.expand_path(File.dirname(__FILE__) + '/../ext/lib_uuid')
  require 'simple_uuid'
  require 'uuidtools'

  class TestCompatibility < Test::Unit::TestCase
    def test_parsing_uuidtools_timestamp_guids
      u = UUIDTools::UUID.timestamp_create
      l = LibUUID::UUID.new(u.to_s)
      assert_equal u.to_s, l.to_guid
      assert_equal 1, l.type
      assert_equal 1, l.variant
    end

    def test_parsing_uuidtools_random_guids
      u = UUIDTools::UUID.random_create
      l = LibUUID::UUID.new(u.to_s)
      assert_equal u.to_s, l.to_guid
      assert_equal 4, l.type
      assert_equal 1, l.variant
    end

    def test_parsing_simple_uuid_guids
      f = SimpleUUID::UUID.new
      g = LibUUID::UUID.new(f.to_guid)
      assert_equal f.to_guid, g.to_guid
      assert_equal 1, g.type
      assert_equal 1, g.variant
    end
  end
rescue LoadError => le
  puts "Skipping compatibility tests: #{le.message}"
end
