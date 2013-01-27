#require 'mysql_set'
=begin
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, MysqlSet::TableDefinition
ActiveRecord::ConnectionAdapters::Mysql2Column.send :include, MysqlSet::MysqlColumn
ActiveRecord::ConnectionAdapters::Mysql2Adapter.send :include, MysqlSet::Mysql2Adapter

silence_warnings do
    c=ActiveRecord::ConnectionAdapters::Mysql2Adapter::NATIVE_DATABASE_TYPES.merge(:set=>{:name=>'set'})
      ActiveRecord::ConnectionAdapters::Mysql2Adapter.const_set("NATIVE_DATABASE_TYPES",c)
end
=end
