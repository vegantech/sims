module CSVImporter
  class RegularUsers < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end
      def description
        "List of users with access to the core functionality of SIMS. Most users should have this role."
      end

      def overwritten
        "Users in this file will be assigned the regular user role."
      end

      def load_order
        "5. This should be done after users are uploaded."
      end

      def removed
        "Users with a district_user_id assignment but not in this file will have the regular_user role unassigned and thus not be able to use most functionality in SIMS."
      end

#      def related
#      end

      def how_often
        "Start of each semester (depending on frequency of new staff may need to be done more or less often; 
        should be done at same time as the \"users\" file)."
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


  end
end

