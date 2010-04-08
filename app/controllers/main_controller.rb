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
    @without=params[:without]

    @stats=ActiveSupport::OrderedHash.new
    [District,DistrictLog,User,School,Student, Recommendation, Checklist, StudentComment, Intervention, InterventionParticipant, Probe, TeamConsultation, 
      ConsultationForm, CustomFlag, SystemFlag, IgnoreFlag, GoalDefinition, ObjectiveDefinition, InterventionCluster, InterventionDefinition
    ].each do |klass|
      if @without
        case klass.name
          when 'Recommendation'
           klass.filter_all_stats_on(:exclude_district_id, "students.district_id != ?")
          when 'District'
           klass.filter_all_stats_on(:exclude_district_id, "districts.id != ?")
          when 'Probe'
           klass.filter_all_stats_on(:exclude_district_id, "students.district_id != ?")
          when /Flag$/
           klass.filter_all_stats_on(:exclude_district_id, "students.district_id != ?")
          else
           klass.filter_all_stats_on(:exclude_district_id, "district_id != ?")
          end
        @stats[klass.name] = klass.statistics(:exclude_district_id => @without.to_i)
      else
       @stats[klass.name] = klass.statistics
      end
    end
    flash[:notice]="Excluding district with id #{@without.to_i}" if @without
  end

end
