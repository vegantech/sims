require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

  describe "csv importer", :shared =>true  do
    it 'should check headers' do

      @i=described_class.new "#{Rails.root}/spec/csv/invalid_headers.csv",@district
      #described class might change to use something like  metadata[:describes]
      @i.import
      @i.messages.should include("Invalid file,  file must have headers #{@i.send(:csv_headers).join(",")} \n\nbut file had This file has incorrect, headers.")

    end
    #end

  end
