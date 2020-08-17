# frozen_string_literal: true

# Generates short, friendly IDs.
class ShortNameGenerator
  def call
    hashids = Hashids.new(SecureRandom.hex) # We don't care about decoding
    hashids.encode_hex(SecureRandom.hex(3))
  end
end
