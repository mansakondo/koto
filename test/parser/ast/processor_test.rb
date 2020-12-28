# frozen_string_literal: true

require 'test_helper'

class ProcessorTest < MiniTest::Test
  include TestHelper

  def test_should_convert_scoped_constants_to_unscoped_constants
    scoped_constant   = Parser.parse("Scoped::Constant")
    unscoped_constant = n(:const, [nil, :"Scoped::Constant"])

    assert_equal unscoped_constant, processor.process(scoped_constant)
  end
end
