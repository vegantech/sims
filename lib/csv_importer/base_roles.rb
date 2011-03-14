module CSVImporter
  class BaseRoles < CSVImporter::Base
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


    private
    def role
      self.class.name.demodulize.tableize.singularize
    end
    def role_mask
      2**Role::ROLES.index(role)
    end

    def index_options
      [[:district_user_id]]
    end


    def migration t
      @col=User.columns_hash["district_user_id"]
      t.string :district_user_id, :limit => @col.limit, :null => @col.null
    end

    def delete
      query = "update users u
      left outer join #{temporary_table_name} t_r on t_r.district_user_id = u.district_user_id
      set u.roles_mask = u.roles_mask & ~#{role_mask},
      u.updated_at = CURDATE()
      where t_r.district_user_id is null and u.district_user_id != '' and u.roles_mask & #{role_mask}
      "
      User.connection.update query
    end

    def insert
      query = "update users u
      inner join #{temporary_table_name} t_r on t_r.district_user_id = u.district_user_id
      set u.roles_mask = u.roles_mask ^ #{role_mask},
      u.updated_at = CURDATE()
      where u.district_user_id != '' and (~u.roles_mask & #{role_mask})
      "
      User.connection.update query
    end
  end
end
