# frozen_string_literal: true

class Object
  def deep_dup
    copy = self.dup

    copy.instance_variables.each do |attr|
      value = instance_variable_get(attr).dup
      copy.instance_variable_set attr, value
    end

    copy
  end
end
