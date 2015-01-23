module DurationConcern
  include ActionView::Helpers::TextHelper #for pluralize
  extend ActiveSupport::Concern


  included do
    belongs_to :time_length
    validates_numericality_of time_length_field
  end

  module ClassMethods
    def time_length_field
      #Unfortunately I ended using two different field values
      #I don't want to change the db as
      #others are using the existing fields
      @time_length_field ||= (column_names & %w(time_length_num time_length_number)).first.to_sym
    end
  end

  def time_length_summary
    pluralize time_length_wrapper, time_length.try(:title).to_s
  end

  def time_length_wrapper
    send self.class.time_length_field
  end


end
