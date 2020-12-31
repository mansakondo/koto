# frozen_string_literal: true

require 'test_helper'

class NameProcessorTest < Minitest::Test
  include TestHelper

  def test_should_process_nested_names
    node = parse("Nested::Constant::Name")
    assert_equal :"Nested::Constant::Name", name_processor.process(node)
  end

  def test_toplevel_constant_name_should_start_with_a_double_colon
    node = parse("::TopLevel::Constant")
    assert_equal :"::TopLevel::Constant", name_processor.process(node)
  end
end
