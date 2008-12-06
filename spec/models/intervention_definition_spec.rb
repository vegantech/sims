# == Schema Information
# Schema version: 20081205205925
#
# Table name: intervention_definitions
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  custom                  :boolean
#  intervention_cluster_id :integer
#  tier_id                 :integer
#  time_length_id          :integer
#  time_length_num         :integer         default(1)
#  frequency_id            :integer
#  frequency_multiplier    :integer         default(1)
#  user_id                 :integer
#  school_id               :integer
#  disabled                :boolean
#  position                :integer
#  rec_mon_preface         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :time_length_id =>1,
      :frequency_id =>1,
      :custom => false,
      :disabled => false,
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionDefinition.create!(@valid_attributes)
  end
end
