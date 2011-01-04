require 'active_record/fixtures'

class Fixtures < (RUBY_VERSION < '1.9' ? YAML::Omap : Hash)

  # I need to use the old references for seed data, this might break on other platforms or versions of ruby.
  # Returns a consistent, platform-independent identifier for +label+.
  # Identifiers are positive integers less than 2^32.
  def self.identify(label)
#    Zlib.crc32(label.to_s) % MAX_ID
    label.to_s.hash.abs
  end
end
