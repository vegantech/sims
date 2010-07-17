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
        "When to upload this file in relation to other files."
      end

      def removed
        "What gets removed when this file is uploaded."
      end

      def related
        "links to related files with explanations."
      end

      def how_often
        "Notes on how often this file should be imported after initial import."
      end

      def alternate
        "links to files that can be used instead of this one, with explanation."
      end

      def upload_responses
        "What you see on the screen or in the email after uploading this file and what the different messages mean. <br />
        In this case you'll see unknown file examples.csv"
      end

    end


  end
end

