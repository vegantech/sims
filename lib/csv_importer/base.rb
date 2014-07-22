module CSVImporter
  require 'csv'
  class Base
    attr_reader :messages
    FIELD_DESCRIPTIONS = {}
    def initialize file_name, district
      @district = district
      @file_name = file_name
      @messages = []
      @clean_file = nil
      @deleted,@updated,@created=nil
      @other_messages = ""
    end

    def import
     return if append_failure?
     if clean_file
        if confirm_count?
          create_temporary_table
          populate_temporary_table
          insert_update_delete
          drop_temporary_table
        end
      end

      @messages << "Successful import of #{File.basename(@file_name)}" if @messages.blank?
      status_count = []
      status_count << "\nCreated- #{@created}" if @created
      status_count << "Deleted- #{@deleted}" if @deleted
      status_count << "Updated- #{@updated}" if @updated

      @messages << status_count.compact.join("; ") unless status_count.compact.blank?
      @messages << @other_messages unless @other_messages.blank?
      @messages.compact.join(", ")
    end

    class << self
      def file_name
        name.tableize.split("/").last+".csv"
      end

      def file_name_with_append
        supports_append? ? name.tableize.split("/").last+"_append.csv" : ''
      end

      def description
        "This needs a description"
      end

      def fields
        csv_headers.join(", ")
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
      end

      def alternate
        {}
      end

      def upload_responses
        "Successful import of #{self.file_name} - means the file could be read"
      end

      def field_detail
      end

      def how_many_rows
      end

      def supports_append?
        false
      end

      def append_info
        "Unsupported for this file"
      end

      def optional_headers
        []
      end
    end

    protected

  def temporary_table_name
    "#{self.class.name.demodulize.tableize}_#{@district.id}_importer"
  end

  def confirm_count?
    if @line_count > 0
      true
    else
      @messages << 'File size below threshold'
      false
    end
  end

    def clean_file
      @line_count = 0

      @clean_file = File.expand_path(File.join(File.dirname(@file_name), "clean_#{File.basename(@file_name)}"))
      #convert bare carriage returns to newlines
      system "sed -i -e 's/\r[^\\n]/\\n/g' #{@file_name}"

      #pop off header
      head= `head -n 1 #{@file_name}`
      return false unless confirm_header head

      system "tail -n +2 #{@file_name} > #{@clean_file}"
      remove_count = '/\([0-9] rows affected\)/d'
      hexify = 's/0[xX]\([a-fA-F0-9]\{40\}\)/\1/'

      a =  "sed -e '/^\\W*$/d' -e 's/, ([JjSs]r)/ \1/' -e 's/NULL//g' -e 's/  *,/,/g' -e 's/  *$//g' -e 's/  *\r/\r/' -e '#{remove_count}' -e '#{hexify}' -e 's/\r$//'  -e 's/,  */,/g' -e 's/^ *//g' -i #{@clean_file}"  #trailing space after quoted fields,  change faster csv to accomodate
      system a
      @messages << 'File could not be found' and return false unless File.exist?(@file_name)

      @line_count = `wc -l #{@clean_file}`.to_i
    end

    def confirm_header row
      h= row.split(",").collect(&:strip)
      h=h.delete_if(&:blank?).collect(&:to_sym)
      if (h - optional_headers).join(",")  == (csv_headers - optional_headers).join(",")
        return h
      else
        @messages << "Invalid file,  file must have headers #{ csv_headers.join(",")} \n\nbut file had #{row.strip[0..511]}"
        return false
      end
    end

    def remove_duplicates
      ActiveRecord::Base.connection.update "alter ignore table #{temporary_table_name} add constraint unique key (#{index_options.join(",")})"
    end

    def remove_duplicates?
      false
    end

    def populate_temporary_table
      ActiveRecord::Base.connection.execute load_data_infile
      remove_duplicates if remove_duplicates?
    end

    def load_data_infile
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}"
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{csv_headers.join(", ")})
            ;
        EOF
    end

    def insert_update_delete
      before_import
      #override this for a different order
      @deleted=delete
      @updated=update
      @created=insert
      after_import
    end

    def before_import
    end

    def after_import
    end

    def delete
    end

    def update
    end

    def insert
    end

    def temporary_table?
      true
    end

    def add_indexes
      index_options.each_with_index do |e,idx|
        ActiveRecord::Migration.add_index temporary_table_name, e, name: "temporary_index_#{idx}"
      end
    end

    def remove_indexes
      index_options.each do |e|
        ActiveRecord::Migration.remove_index temporary_table_name, *e
      end
    end

    def create_temporary_table
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Migration.create_table temporary_table_name, id: false, temporary: temporary_table? do |t|
          migration t
        end
        add_indexes
      end
    end

    def drop_temporary_table
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Migration.drop_table temporary_table_name if temporary_table?
      end
    end

    def sims_model
    end

    private
    def csv_headers
      self.class.csv_headers
    end

    def optional_headers
      self.class.optional_headers
    end

    def append_failure?
      if @file_name.match /_append[s]?/
        if self.class.supports_append?
          @append = true
          return false
        else
          @messages << "Append is not supported for #{self.class.file_name}"
          return true
        end
      end
      return false
    end
  end
end
