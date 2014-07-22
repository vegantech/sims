module CSVImporter
  class Examples < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      district_example_id: 'the primary key used in the student information system by the district',
      example_text: 'some other field'
    }
    class << self
      def description
        "An example file used to show the format."
      end

      def csv_headers
        [:district_example_id, :example_text]
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
        {examples: "links to related files with explanations."}
      end

      def how_often
        "Notes on how often this file should be imported after initial import."
      end

      def alternate
        {examples: "links to files that can be used instead of this one, with explanation."}
      end

      def upload_responses
        "What you see on the screen or in the email after uploading this file and what the different messages mean. <br />
        In this case you'll see unknown file examples.csv"
      end

      def how_many_rows
        "There should be one row per example."
      end
    end
  end
end

