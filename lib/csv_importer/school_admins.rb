module CSVImporter
  class SchoolAdmins < CSVImporter::BaseRoles
    FIELD_DESCRIPTIONS = {
      district_user_id: "Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end
      def description
        "This is no longer used.  See the admins_of_schools.csv instead."
      end

      def overwritten
      end

      def load_order
      end

      def removed
      end

      def related
        {}
      end

      def how_often
        ""
      end

      def alternate
        {"admins_of_schools" => "Use this file instead"}
      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user with this access."
      end
    end

    def import
      "school_admins.csv is no longer used.  Use admins_of_schools.csv instead"
    end
  end
end

