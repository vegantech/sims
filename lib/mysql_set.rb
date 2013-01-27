#require 'active_record/connection_adapters/mysql_adapter'

module MysqlSet
    module TableDefinition
      def set(*args)
        options = args.extract_options!                                       #   options = args.extract_options!a
        column_names = args
        column_names.each {|name| column(name,'set',options)}
      end
    end

    module MysqlColumn# < Column
      def simplified_type(field_type)
        return :set if field_type =~ /set/i
        super
      end

      def initialize(name, default, sql_type = nil, null = true)
        super
        if sql_type =~ /^set/i && @type != :set
          @type = :set
        end
      end
      private
     def extract_limit(sql_type)
      if sql_type =~ /^set/i
        sql_type[4..-2]
      else
        super
      end
      end

   end

    module  Mysql2Adapter
     def type_to_sql(type, limit = nil, precision = nil, scale = nil)
        if type == :set
          native = native_database_types[type]
          column_type_sql =  'set'
          if limit.is_a? String
            limit = limit.gsub(/'/,"").split(/,[ ]?/)
          end
          column_type_sql << "(#{limit.map { |v| quote(v) }.join(',')})"
          column_type_sql
        else
          super
        end
      end

    end
end


