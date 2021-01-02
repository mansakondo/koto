# frozen_string_literal: true

require "test_helper"

class ParserTest < Minitest::Test
  include TestHelper

  def test_should_return_a_custom_node
    node = parse "class Node; end"
    assert node.is_a? Koto::Parser::AST::Node
  end
end
