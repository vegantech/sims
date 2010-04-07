class MainController < ApplicationController
  skip_before_filter :authenticate, :authorize, :only=>[:index,:stats]
  include  CountryStateDistrict
  def index
    redirect_to logout_url if current_district.blank? and current_user_id.present?
    if current_user and current_user.authorized_schools.present? and current_user.authorized_for?('schools','read_access')
      redirect_to schools_url and return
    end
    dropdowns
  end

  def stats
    @stats=ActiveSupport::OrderedHash.new
    [District,DistrictLog,User,School,Student, Recommendation, Checklist, StudentComment, Intervention, InterventionParticipant, Probe, TeamConsultation, 
      ConsultationForm, CustomFlag, SystemFlag, IgnoreFlag, GoalDefinition, ObjectiveDefinition, InterventionCluster, InterventionDefinition
    ].each do |klass|
      @stats[klass.name] = klass.statistics
    end
  end

end
