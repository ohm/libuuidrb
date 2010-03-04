require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../ext/lib_uuid')

class TestLibUUUID < Test::Unit::TestCase

  EXPR = {
    :rfc => /\A[a-z0-9]{8}\-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\Z/,
    :b64 => /\A[A-Za-z0-9\-\_]{22}\Z/
  }

  def test_guid_generation
    guids = []
    1.upto(100) { guids << LibUUID::UUID.guid }
    assert_equal guids.size, guids.uniq.size
    assert_equal guids.size, guids.reject {|g| (g =~ EXPR[:rfc]) != 0}.size
  end

  def test_short_guid_generation
    short_guids = []
    1.upto(100) { short_guids << LibUUID::UUID.short_guid }
    assert_equal short_guids.size, short_guids.uniq.size
    assert_equal short_guids.size, short_guids.reject { |sg| (sg =~ EXPR[:b64]) != 0 }.size
  end

  def test_initialization
    u = LibUUID::UUID.new
    assert LibUUID::UUID == u.class
    assert 4 == u.type
    assert 1 == u.variant
  end

  def test_positive_equality
    u = LibUUID::UUID.new
    assert u == u
  end

  def test_negative_equality
    u = LibUUID::UUID.new
    v = LibUUID::UUID.new
    assert u != v
    assert u != 1
    assert u != nil
    assert u != 'foo'
  end

  def test_transformation_to_guid
    u = LibUUID::UUID.new
    assert_match EXPR[:rfc], u.to_guid
    assert u.to_guid == u.to_guid
  end

  def test_transformation_to_short_guid
    u = LibUUID::UUID.new
    assert_match EXPR[:b64], u.to_short_guid
    assert u.to_short_guid == u.to_short_guid
  end

  def test_parsing_guids
    assert_nil LibUUID::UUID.new(nil)
    assert_nil LibUUID::UUID.new(123)
    assert_nil LibUUID::UUID.new('foo')

    u = LibUUID::UUID.new
    assert u == LibUUID::UUID.new(u.to_guid)
    assert u == LibUUID::UUID.new(u.to_short_guid)

    assert_raise ArgumentError do
      LibUUID::UUID.new(u.to_guid, u.to_guid)
    end
  end

  def test_positive_validating_guids_and_short_guids
    assert LibUUID::UUID.valid?(LibUUID::UUID.guid)
    assert LibUUID::UUID.valid?(LibUUID::UUID.short_guid)
    assert LibUUID::UUID.valid?(LibUUID::UUID.guid, LibUUID::UUID.guid)
    assert LibUUID::UUID.valid?(LibUUID::UUID.guid, LibUUID::UUID.short_guid)
    assert LibUUID::UUID.valid?(LibUUID::UUID.short_guid, LibUUID::UUID.short_guid)
  end

  def test_negative_validating_guids_and_short_guids
    assert false == LibUUID::UUID.valid?(1)
    assert false == LibUUID::UUID.valid?('foo', LibUUID::UUID.short_guid)
    assert false == LibUUID::UUID.valid?(nil, 'foo', LibUUID::UUID.guid)

    assert_raise ArgumentError do
      LibUUID::UUID.valid?
    end
  end

  def test_accessing_raw_bytes
    examples = {
      "99744ce4-22ef-11df-9985-b2d60a1a84bd" =>
        "\x99tL\xE4\"\xEF\x11\xDF\x99\x85\xB2\xD6\n\x1A\x84\xBD",
      "9974502c-22ef-11df-9ef4-56b2ae6e82ba" =>
        "\x99tP,\"\xEF\x11\xDF\x9E\xF4V\xB2\xAEn\x82\xBA",
      "9974525c-22ef-11df-83d0-49d493d646c4" =>
        "\x99tR\\\"\xEF\x11\xDF\x83\xD0I\xD4\x93\xD6F\xC4",
      "9974546e-22ef-11df-9f68-0d1a49a6205e" =>
        "\x99tTn\"\xEF\x11\xDF\x9Fh\r\x1AI\xA6 ^",
      "99745680-22ef-11df-94f8-8f1188b64943" =>
        "\x99tV\x80\"\xEF\x11\xDF\x94\xF8\x8F\x11\x88\xB6IC"
    }

    examples.each do |guid, bytes|
      l = LibUUID::UUID.new(guid)
      assert_equal bytes, l.bytes
    end
  end
end
