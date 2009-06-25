module CSVImporter
  class Base

    def initialize file_name, district
      @district = district
      @file_name = file_name
      @messages = []
      @clean_file = nil
    end

    def import

      if confirm_header
        clean_file
        if confirm_count?
          create_temporary_table
          populate_temporary_table
          insert_update_delete
          drop_temporary_table
        end
      end

      @messages.join(", ")
    end

  protected
  
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
      output = FasterCSV.open(@clean_file, "w")
      FasterCSV.foreach(@file_name, ImportCSV::DEFAULT_CSV_OPTS) do |row|
        unless row[0] =~  /^-+|\(\d+ rows affected\)$/
          output << row
          @line_count = @line_count +1
        end
      end
      output.close
    end

       
    def confirm_header
      if  `head -n1 #{@file_name}`.strip == csv_headers.join(",")
        return true
      else
        @messages << "Invalid file,  file must have headers #{ csv_headers.join(",")}"
        return false
      end
    end

    def populate_temporary_table
      ActiveRecord::Base.connection.execute load_data_infile
    end

    def load_data_infile
      <<-EOF
          LOAD DATA INFILE "#{@clean_file}" 
            INTO TABLE csv_importer
            FIELDS TERMINATED BY ','
            (#{csv_headers.join(", ")})
            ;
        EOF
    end
    
    def insert_update_delete
      #override this for a different order
      delete
      update
      insert
    end

    def delete
    end
    
    def update
    end
    
    def insert
    end

    def add_indexes
      index_options.each_with_index do |e,idx|
         ActiveRecord::Migration.add_index 'csv_importer', e, :name=>"temporary_index_#{idx}"
      end
    end

    def remove_indexes
      index_options.each do |e|
        ActiveRecord::Migration.remove_index 'csv_importer', *e
      end
    end

    def create_temporary_table 
      ActiveRecord::Migration.create_table 'csv_importer', :id => false, :temporary => true do |t|
        migration t
      end
      add_indexes
    end

    def drop_temporary_table
      ActiveRecord::Migration.drop_table 'csv_importer'
    end
  end
end
