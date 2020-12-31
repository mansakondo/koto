# frozen_string_literal: true

require 'test_helper'

class ProcessorTest < MiniTest::Test
  include TestHelper

  def test_should_convert_scoped_constants_to_unscoped_constants
    scoped_constant   = parse("Scoped::Constant")
    unscoped_constant = n(:const, [nil, :"Scoped::Constant"])
    assert_equal unscoped_constant, process(scoped_constant)
  end

  def test_should_assign_name_to_named_nodes
    node = parse("class Name; end")
    node = process(node)
    assert node.name
  end
end
