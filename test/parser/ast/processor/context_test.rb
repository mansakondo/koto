# frozen_string_literal: true

require "test_helper"

class ContextTest < Minitest::Test
  include TestHelper

  def test_current_scope
    c = context
    assert c.top_level?

    mod = parse "module AST; end"
    c.get_in(mod)
    assert c.in_module?

    klass = parse "class Context; end"
    c.get_in(klass)
    assert c.in_class?

    method = parse "def get_in(node); end"
    c.get_in(method)
    assert c.in_def?
  end
end
