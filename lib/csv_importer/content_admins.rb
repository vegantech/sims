module CSVImporter
  class ContentAdmins < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end

      def description
        "List of users with access to the content builders."
      end

      def overwritten
      end

      def load_order
        "After users are uploaded."
      end

      def removed
      end

#      def related
#      end

      def how_often
        "You might find this easier to handle manually within SIMS itself.  Otherwise, whenever you want to designate different content administrators."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

    end


  end
end

