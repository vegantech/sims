module CSVImporter
  class SystemFlags < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        :district_student_id =>"Key for student",
        :category =>"Type of flag, currently one of #{Flag::FLAGTYPES.keys.join(", ")}",
        :reason =>"A description of the reason the student was flagged.",
    }
    class << self
      def description
        "Student Flags"
      end

      def csv_headers
        [:district_student_id, :category, :reason]
      end

      def overwritten
        "What will get overwritten/changed when this file is uploaded."
      end

      def load_order
      end

      def removed
      end

      def related
      end

      def how_often
      end

      def alternate
      end

      def upload_responses
        super
      end

    end


  end
end

