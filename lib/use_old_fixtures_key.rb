require 'active_record/fixtures'

module UseOldFixturesKey
  STATIC_IDENTIFY_VALUES = {
    :alpha_first_attendance => 184330814,
    :wi_mmsd => 647352205,
    :day => 858529777,
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

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      class << self
        alias_method_chain :identify, :static
      end
    end
  end

  module ClassMethods
    def identify_with_static(label)
      STATIC_IDENTIFY_VALUES[label.to_sym] || identify_without_static(label)
    end
  end
end
