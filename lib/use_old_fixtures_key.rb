require 'active_record/fixtures'

class Fixtures < (RUBY_VERSION < '1.9' ? YAML::Omap : Hash)
  STATIC_IDENTIFY_VALUES = {
    :alpha_first_attendance => 184330814,
    :day => 1704995217,
    :week => 1532651968,
    :month => 246812679,
    :quarter => 478273799,
    :semester => 2000195310,
    :year => 998404920,
    :daily => 245214059,
    :weekly => 1591519780,
    :biweekly => 115112478,
    :monthly => 1789249177,
    :as_needed => 671893021,
    :recommendation_answer_definition_00001 => 2066095351,
    :recommendation_answer_definition_00002 => 1647267150,
    :recommendation_answer_definition_00003 => 354975196,
    :recommendation_answer_definition_00004 => 189589624,
    :recommendation_answer_definition_00005 => 2085345518,
    :recommendation_definition_00001 => 727837652,
    :recommendation_definition_00002 => 542279545,
  }
  # I need to use the old references for seed data, this might break on other platforms or versions of ruby.
  # Returns a consistent, platform-independent identifier for +label+.
  # Identifiers are positive integers less than 2^32.

  def self.identify(label)
    STATIC_IDENTIFY_VALUES[label.to_sym] ||  (Zlib.crc32(label.to_s) % MAX_ID)
  end
end
