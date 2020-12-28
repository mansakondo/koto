# frozen_string_literal: true

require 'test_helper'

class NameProcessorTest < Minitest::Test
  include TestHelper

  def test_should_process_nested_names
    node = Parser.parse("Nested::Constant::Name")
    assert_equal :"Nested::Constant::Name", name_processor.process(node)
  end

  def test_toplevel_constant_should_start_with_a_double_colon
    node = Parser.parse("::TopLevel::Constant")
    assert_equal :"::TopLevel::Constant", name_processor.process(node)
  end
end
