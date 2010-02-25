class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
#    can :manage, :all

    can :news, :all do |item, parent|
        if user.role?('news_admin') 
          parent = System if parent.nil?
          user.district == parent || user.district.try(:administers) == parent
        end
    end

    can :read, School do |school|
      (user.roles & ['regular_user','school_admin']).present? && user.authorized_schools.present?  
    end

    can :read, Student do |student|
      user.role?('regular_user')
    end

    can :read, Railmail unless user.new_record?


  end

end
