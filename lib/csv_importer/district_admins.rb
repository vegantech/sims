module CSVImporter
  class DistrictAdmins < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end

      def description
        "List of users with access to the district admin tools. This should be limited, as the district admin tools 
        would allow users to assign themselves additional rights. "
      end

      def overwritten
      end

      def load_order
        "This can be uploaded after users."
      end

      def removed
      end

#      def related
#      end

      def how_often
        "You will likely prefer to do this manually within SIMS.  Otherwise, whenever you want to designate different district administrators.  Be sure
        to include your own account in the file."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

    end


  end
end

