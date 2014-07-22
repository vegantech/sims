module CSVImporter
  class DistrictAdmins < CSVImporter::BaseRoles
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end

      def description
        "List of users with access to the district admin tools. This should be limited, as the district admin tools 
        would allow users to assign themselves additional rights. Now called Local System Administrator."
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
        "Start of school year, or handle manually.  Be sure to include your own account in the file so you don't lock yourself out."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user with this access."
      end
    end

    private

    def role
      "local_system_administrator"
    end
  end
end

