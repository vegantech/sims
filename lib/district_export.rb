require 'fileutils'
require 'fastercsv'
class DistrictExport
  def self.generate(district)
    dir = "#{RAILS_ROOT}/tmp/district_export/#{district.id}/"
    
    FileUtils.mkdir_p dir unless File.exists? dir
    FileUtils.rm(Dir.glob(dir +"*"))

    self.generate_csv(dir,district,'students', 'id,district_student_id')
    self.generate_csv(dir,district,'users', 'id,district_user_id')
    self.generate_csv(dir,district,'schools', 'id,district_school_id')
    self.generate_csv(dir,district,'interventions', Intervention.column_names.join(","), "inner join users on interventions.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'intervention_probe_assignments', InterventionProbeAssignment.column_names.join(","), "inner join interventions on intervention_probe_assignments.intervention_id = interventions.id inner join users on interventions.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'probes', Probe.column_names.join(","), "inner join intervention_probe_assignments on intervention_probe_assignments.id = probes.intervention_probe_assignment_id inner join interventions on intervention_probe_assignments.intervention_id = interventions.id inner join users on interventions.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'intervention_comments', InterventionComment.column_names.join(","), "inner join interventions on intervention_comments.intervention_id = interventions.id inner join users on interventions.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'student_comments', StudentComment.column_names.join(","), "inner join users on student_comments.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'recommendations', Recommendation.column_names.join(","), "inner join users on recommendations.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'recommendation_answers', RecommendationAnswer.column_names.join(","), "inner join recommendations on recommendations.id = recommendation_answers.recommendation_id inner join users on recommendations.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'checklists', Checklist.column_names.join(","), "inner join users on checklists.user_id = users.id and users.district_id = #{district.id}")
    self.generate_csv(dir,district,'answers', Answer.column_names.join(","), "inner join checklists on answers.checklist_id = checklists.id inner join users on checklists.user_id = users.id and users.district_id = #{district.id}")

    
    #zip files
  end



  def self.generate_csv(dir,district, table, headers, conditions="where district_id = #{district.id}")
     FasterCSV.open("#{dir}#{table}.csv", "w") do |csv|
      csv << headers.split(',')
      select= headers.split(',').collect{|h| "#{table}.#{h}"}.join(",")
      Student.connection.select_rows("select #{select} from #{table} #{conditions}").each do |row|
        csv << row
      end
    end
    
  end
end
