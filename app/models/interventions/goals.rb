class Interventions::Goals
  extend ActiveModel::Naming

  def initialize(district)
    @district = district
  end

  def goals
    @district.goal_definitions.enabled
  end

  def id
    1
  end

end
