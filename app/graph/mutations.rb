module Mutations
  def self.bitstring_to_int(bitstring)
    memo = 0
    Array(bitstring.try(:chars)).each_with_index do |bit, i|
      bit = bit.to_i
      memo |= 1 << i unless bit.zero?
    end
    memo
  end
end
