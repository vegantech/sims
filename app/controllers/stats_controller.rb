class StatsController < ApplicationController
  skip_before_filter :authenticate_user!, :authorize

  def index
    #TODO test and refactor
    flash[:notice]=nil

    @without=params[:without]

    begin
      @start_date = Date.parse(params[:start]).to_date
    rescue
      @start_date = "2009-10-01".to_date
    end

    begin
      @end_date = Date.parse(params[:end]).to_date
    rescue
      @end_date = 1.day.since.to_date
    end


    @stats=ActiveSupport::OrderedHash.new
    [District,DistrictLog,User,School,Student, Recommendation, Checklist, StudentComment, Intervention, InterventionParticipant, Probe, TeamConsultation,
      ConsultationForm, CustomFlag, SystemFlag, IgnoreFlag, GoalDefinition, ObjectiveDefinition, InterventionCluster, InterventionDefinition
    ].each do |klass|
      klass.filter_all_stats_on(:created_after, "DATE(#{klass.table_name}.created_at) >= DATE(?)")
      klass.filter_all_stats_on(:created_before, "DATE(#{klass.table_name}.created_at) <= DATE(?)")
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
        @stats[klass.name] = klass.statistics(:exclude_district_id => @without.to_i, :created_after=> @start_date, :created_before => @end_date)
      else
        @stats[klass.name] = klass.statistics(:created_after=> @start_date, :created_before => @end_date)
      end
    end
    flash.now[:notice]="Excluding district with id #{@without.to_i}" if @without
  end

end
