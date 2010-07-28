module CSVImporter
  class BaseSystemFlags < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        :district_student_id =>"Key for student",
        :reason =>"A description of the reason the student was flagged.",
    }
    class << self
      def flag_category
        self.file_name.split("_system_flags").first
      end
      def description
        "Student Flags for category #{Flag::FLAGTYPES[flag_category][:humanize]}"
      end

      def csv_headers
        [:district_student_id, :reason]
      end

      def overwritten
        "Students with district_student_id assigned will have their system flags reset."
      end

      def load_order
        "This should be loaded after students, and after the system_flags file if that is used."
      end

      def removed
        "All flags (except ignored or custom) for students with district_student_id assigned will be removed and recreated by this file"
      end

#      def related
#      end

      def how_often
      end

      def alternate
        {:system_flags => "You can put all categories together in one file instead.  It's possible to do some categories combined in the system flags file and
          do the rest individually as long as you load the system flags first." }
      end

      def upload_responses
        super
      end

    end
  end


  Flag::FLAGTYPES.keys.each do |key|
     CSVImporter::const_set("#{key.capitalize}SystemFlags".intern, Class::new(CSVImporter::BaseSystemFlags) do 
    
    end)

  end


end
