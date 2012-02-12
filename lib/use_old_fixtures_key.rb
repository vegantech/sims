require 'active_record/fixtures'

class Fixtures < (RUBY_VERSION < '1.9' ? YAML::Omap : Hash)
  STATIC_IDENTIFY_VALUES = {
    :alpha_first_attendance => 184330814,
    :day => 85852977,
    :week => 782065165,
    :month => 785548667,
    :quarter => 601648301,
    :semester => 503752779,
    :year => 827625344,
    :daily => 529071850,
    :weekly => 680074761,
    :biweekly => 284292352,
    :monthly => 939654166,
    :as_needed => 344418694,
    :recommendation_answer_definition_00001 => 1,
    :recommendation_answer_definition_00002 => 2,
    :recommendation_answer_definition_00003 => 3,
    :recommendation_answer_definition_00004 => 4,
    :recommendation_answer_definition_00005 => 5,
    :recommendation_definition_00001 => 1,
    :recommendation_definition_00002 => 2,
  }
  # I need to use the old references for seed data, this might break on other platforms or versions of ruby.
  # Returns a consistent, platform-independent identifier for +label+.
  # Identifiers are positive integers less than 2^32.

  def self.identify(label)
    STATIC_IDENTIFY_VALUES[label.to_sym] ||  (Zlib.crc32(label.to_s) % MAX_ID)
  end
end
