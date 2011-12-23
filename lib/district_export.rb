require 'fileutils'
require 'fastercsv'
class DistrictExport
  def self.generate(district)
    self.new.generate(district)
  end

  def no_double_quotes field
    return if field.blank?
        string=field.to_s
        string.gsub! /\342\200\230/m, "'"
        string.gsub! /\342\200\231/m, "'"
        string.gsub! /\342\200\234/m, '"'
        string.gsub! /\342\200\235/m, '"'
        string.gsub! /\t/m, '   '
        return (string.gsub /"/m, "''")
  end

  def generate(district)
    @files=Hash.new
    dir = "#{Rails.root}/tmp/district_export/#{district.id}/"
    
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


    self.generate_csv(dir,district,'checklist_definitions', ChecklistDefinition.column_names.join(","))
    self.generate_csv(dir,district,'question_definitions', QuestionDefinition.column_names.join(","), "inner join checklist_definitions on checklist_definitions.id = question_definitions.checklist_definition_id and checklist_definitions.district_id = #{district.id}")
    self.generate_csv(dir,district,'element_definitions', ElementDefinition.column_names.join(","), "inner join question_definitions on question_definitions.id = element_definitions.question_definition_id inner join checklist_definitions on checklist_definitions.id = question_definitions.checklist_definition_id and checklist_definitions.district_id = #{district.id}")
    self.generate_csv(dir,district,'answer_definitions', AnswerDefinition.column_names.join(","), "inner join element_definitions on element_definitions.id = answer_definitions.element_definition_id inner join question_definitions on question_definitions.id = element_definitions.question_definition_id inner join checklist_definitions on checklist_definitions.id = question_definitions.checklist_definition_id and checklist_definitions.district_id = #{district.id}")
    

    self.generate_csv(dir,district,'tiers', Tier.column_names.join(","))
    self.generate_csv(dir,district,'goal_definitions', GoalDefinition.column_names.join(","))
    self.generate_csv(dir,district,'objective_definitions', ObjectiveDefinition.column_names.join(","), "inner join goal_definitions on goal_definitions.id = objective_definitions.goal_definition_id where goal_definitions.district_id = #{district.id}")
    self.generate_csv(dir,district,'intervention_clusters', InterventionCluster.column_names.join(","), "inner join objective_definitions on objective_definitions.id = intervention_clusters.objective_definition_id inner join goal_definitions on goal_definitions.id = objective_definitions.goal_definition_id where goal_definitions.district_id = #{district.id}")
    self.generate_csv(dir,district,'intervention_definitions', InterventionDefinition.column_names.join(","), "inner join intervention_clusters on intervention_clusters.id = intervention_definitions.intervention_cluster_id inner join objective_definitions on objective_definitions.id = intervention_clusters.objective_definition_id inner join goal_definitions on goal_definitions.id = objective_definitions.goal_definition_id where goal_definitions.district_id = #{district.id}")

    self.generate_csv(dir,district,'probe_definitions', ProbeDefinition.column_names.join(","))
    self.generate_csv(dir,district,'probe_definition_benchmarks', ProbeDefinitionBenchmark.column_names.join(","), 
                      "inner join probe_definitions on probe_definitions.id = probe_definition_benchmarks.probe_definition_id and probe_definitions.district_id = #{district.id}")
    self.generate_csv(dir,district,'recommended_monitors', RecommendedMonitor.column_names.join(","), "inner join probe_definitions on probe_definitions.id = recommended_monitors.probe_definition_id and probe_definitions.district_id = #{district.id}")

    self.generate_csv(dir,district,'recommendation_definitions', RecommendationDefinition.column_names.join(","),'')
    self.generate_csv(dir,district,'recommendation_answer_definitions', RecommendationAnswerDefinition.column_names.join(","),'inner join recommendation_definitions on recommendation_answer_definitions.recommendation_definition_id = recommendation_definitions.id')
    assets = district.probe_definitions.collect(&:assets).flatten.compact | 
      district.goal_definitions.collect(&:objective_definitions).flatten.collect(&:intervention_clusters).flatten.collect(&:intervention_definitions).flatten.collect(&:assets).flatten.compact

    self.generate_csv(dir,district,'assets',Asset.column_names.join(","),"where id in (#{assets.collect(&:id).join(",")})") unless assets.blank?

    curl_string = "curl -o sims_export.zip --user district_upload:PASSWORD #{district.url 'scripted/district_export'} -k"

    File.open("#{dir}sims_export.bat", 'w') {|f| f.write(curl_string)}
    File.open("#{dir}sims_export.sh", 'w') {|f| f.write(curl_string)}

    self.generate_schema dir
    system "zip -j -qq #{dir}sims_export.zip #{dir}*"
   
    "#{dir}sims_export.zip"
    #zip files
  end


  def generate_schema dir
     File.open("#{dir}schema.txt","a+") do |f| 
       @files.keys.sort.each do |table|
         f.write("#{table}\r\n")
         @files[table].split(',').each do |header|
           obj=table.classify.constantize
           col=obj.columns.find{|col| col.name == header}
           f.write("#{header} - #{col.type} - #{col.sql_type}\r\n" )
         end
         f.write("\r\n")
       end
     end

  end

  def generate_csv(dir,district, table, headers, conditions="where district_id = #{district.id}")
    @files[table]=headers
    FasterCSV.open("#{dir}#{table}.tsv", "w",:row_sep=>" |\r\n",:col_sep =>"\t" ) do |tsv|
    FasterCSV.open("#{dir}#{table}.csv", "w",:row_sep=>"\r\n") do |csv|
      csv << headers.split(',')
      tsv << headers.split(',')
      select= headers.split(',').collect{|h| "#{table}.#{h}"}.join(",")
      Student.connection.select_rows("select #{select} from #{table} #{conditions}").each do |row|
        csv << row
        tsv << row.collect{|c| no_double_quotes(c)}
      end
    end;end
    
  end

  def create_tables
    @files.keys.sort.each do |table|
      puts "CREATE TABLE #{table} ("
      cols= @files[table].split(',').collect do |header|
        obj=table.classify.constantize
        col=obj.columns.find{|col| col.name == header}
        sql_type=col.sql_type
        sql_type=sql_type.split("(").first if sql_type.include?("int")
        sql_type="datetime" if sql_type == "date"
        sql_type="int" if sql_type == "tinyint"
        "#{header} #{sql_type}" 
      end.join(", ")
      puts cols
      puts ");"

    end
  end

  def sqlserver_bulk_import db,dir
    puts "use #{db}"
    puts "set nocount on"

    @files.keys.sort.each do |table|
      puts "truncate table #{table}"
      puts "bulk insert #{table} from \"#{dir}#{table}.tsv\""
      puts "with ( ROWTERMINATOR = '\\n', FIELDTERMINATOR ='\\t', FIRSTROW=2)"
    end
  end
end
