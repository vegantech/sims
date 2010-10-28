# == Schema Information
# Schema version: 20101027022939
#
# Table name: assets
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  url                   :string(255)
#  attachable_id         :integer(4)
#  attachable_type       :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer(4)
#  document_updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Asset do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :url => "value for url",
      #      :attachable => 
    }
  end

  it "should create a new instance given valid attributes" do
    Asset.create!(@valid_attributes)
  end
end
