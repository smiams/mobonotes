module Utilities
  def self.get_keys_from_2d_array(array)
    array.collect { |item| item[0] }
  end
end