require 'active_record/connection_adapters/mysql_adapter'
module ActiveRecord
  module ConnectionAdapters
    class TableDefinition
      def set(*args)
        options = args.extract_options!                                       #   options = args.extract_options!
        column_names = args                                                   #   column_names = args
        #
        column_names.each { |name| column(name, "set", options) }  #   column_names.each { |name| column(name, 'string', options) }
      end
    end

    class MysqlColumn < Column
      private
      def extract_limit(sql_type)
        case sql_type
        when /blob|text/i
          case sql_type
          when /tiny/i
            255
          when /medium/i
            16777215
          when /long/i
            2147483647 # mysql only allows 2^31-1, not 2^32-1, somewhat inconsistently with the tiny/medium/normal cases
          else
            super # we could return 65535 here, but we leave it undecorated by default
          end
        when /^bigint/i;    8
        when /^int/i;       4
        when /^mediumint/i; 3
        when /^smallint/i;  2
        when /^tinyint/i;   1
        when /^set/i;  sql_type[4..-2]
        else
          super
        end
      end

      def simplified_type(field_type)
        return :set if field_type =~ /^set/
        return :boolean if MysqlAdapter.emulate_booleans && field_type.downcase.index("tinyint(1)")
        return :string  if field_type =~ /enum/
        super
      end
    end
  end
end
silence_warnings do
  c=ActiveRecord::ConnectionAdapters::MysqlAdapter::NATIVE_DATABASE_TYPES.merge(:set=>{:name=>'set'})
  ActiveRecord::ConnectionAdapters::MysqlAdapter.const_set("NATIVE_DATABASE_TYPES",c)
end

