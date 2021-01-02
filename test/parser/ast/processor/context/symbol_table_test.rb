# frozen_string_literal: true

require "test_helper"

class SymbolTableTest < Minitest::Test
  include TestHelper

  def test_symbol_table
    node = parse "class Context; end"
    node = process node

    sym_table = symbol_table
    sym_table.record(node)
    assert sym_table[:Context]
  end
end
