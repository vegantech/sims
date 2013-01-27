# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_test_scores
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  name       :string(255)
#  date       :date
#  scaleScore :float
#  result     :string(255)
#  enddate    :date
#  created_at :datetime
#  updated_at :datetime
#

class ExtTestScore < ActiveRecord::Base
  belongs_to :student

  PROFICIENCIES=[nil,"1-minimal", "2-basic", "3-proficient", "4-advanced"]
  TEST_GROUPS=Hash.new {|h,k| h[k] = "#{k}: Results given as scaled score / result"}
  TEST_GROUPS.merge!("PMA"=> "Primary Math Assessment", "PLAA"=>"Primary Language Arts Assessment",
  "DWS"=>"District Writing Sample: Results given as scaled score", "WKCE"=>"WKCE")

  def test_group
    if name and name.split[0].upcase == name.split[0]
      name.split[0]
    else
      'Other'
    end
  end

  def grade
    g=name.split[1] if name
    g=name.split[2] if g=="Fall" or g=="Spr"
    g="" unless g=="K" or (1..12).include?(g.to_i)

    g
  end

  def description
    d=name.split[1..-1] if name.split[0].upcase == name.split[0]
    d=name.split unless d
    d.delete grade
    d.delete "Fall"
    d.delete "Spr"
    d.join " "

  end
  def score
    s= case test_group
    when "PMA","PLAA", "WKCE"
      PROFICIENCIES[result.to_i]
    when "DWS"
      "#{scaleScore.to_i}"
    else
      "#{scaleScore.to_f}/#{result.to_f}"
    end
    s="#{scaleScore.to_i}" if name.include?("Text Reading Lvl")
    s
  end

  def to_s
    "#{description}: #{score}"
  end

  def <=>(rhs)
    if self.date && rhs.date
      self.date <=> rhs.date
    else
      self.name.to_s <=> rhs.name.to_s
    end
  end
end
