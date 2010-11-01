# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_clusters
#
#  id                      :integer(4)      not null, primary key
#  title                   :string(255)
#  description             :text
#  objective_definition_id :integer(4)
#  position                :integer(4)
#  disabled                :boolean(1)
#  created_at              :datetime
#  updated_at              :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionCluster do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :position => "1",
      :disabled => false
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionCluster.create!(@valid_attributes)
  end
end
