# == Schema Information
# Schema version: 20090428193630
#
# Table name: intervention_clusters
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  objective_definition_id :integer
#  position                :integer
#  disabled                :boolean
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer
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
