require 'fileutils'
require 'csv'
class DistrictExport
  attr_reader :dir,:district

  TO_EXPORT = [
    :answers,
    :answer_definitions,
    :checklists,
    :checklist_definitions,
    :consultation_forms,
    :consultation_form_concerns,
    :consultation_form_requests,
  #  :custom_flags,
  #  :district_logs,
    :element_definitions,
    :flag_categories,
    :flag_descriptions,
    :frequencies,
    :goal_definitions,
   # :ignore_flags,
    :interventions,
    :intervention_clusters,
    :intervention_comments,
    :intervention_definitions,
    :intervention_probe_assignments,
    :news_items,
    :objective_definitions,
    :probes,
    :principal_overrides,
    :probe_definitions,
    :probe_definition_benchmarks,
    :question_definitions,
    :recommendations,
    :recommendation_answers,
    :recommendation_answer_definitions,
    :recommendation_definitions,
    :recommended_monitors,
    :schools,
    :school_teams,
    :school_team_memberships,
    :students,
    :student_comments,
    :team_consultations,
    :tiers,
    :time_lengths
  ]
  SPECIAL_COLS={
    :students => "id,district_student_id",
    :schools => "id,district_school_id",
  }

  CONTENT_ONLY = [
    :assets,
    :answer_definitions,
    :checklist_definitions,
    :element_definitions,
    :goal_definitions,
    :intervention_clusters,
    :intervention_definitions,
    :objective_definitions,
    :probe_definitions,
    :probe_definition_benchmarks,
    :question_definitions,
    :recommendation_answer_definitions,
    :recommendation_definitions,
    :recommended_monitors,
    :tiers
  ]

  def self.generate(district)
    self.new(district).generate
  end

  def self.export_content(district)
    self.new(district).export_content
  end

  def initialize(district)
    @district = district
    @dir = Rails.root.join("tmp","district_export",district.id.to_s)
    @content_dir = Rails.root.join("tmp","content_export",district.id.to_s)
    @files=Hash.new
    @student_ids_in_use = []
  end

  def no_double_quotes field
    return if field.blank?
        string=field.to_s.encode('utf-8','binary', :invalid => :replace, :undef => :replace, :replace => '')
        string.gsub! /\342\200\230/m, "'"
        string.gsub! /\342\200\231/m, "'"
        string.gsub! /\342\200\234/m, '"'
        string.gsub! /\342\200\235/m, '"'
        string.gsub! /\t/m, '   '
        return (string.gsub /"/m, "''")
  end

  def setup_directory(dir = dir)
    dir.rmtree if dir.exist?
    dir.mkpath
  end

  def csv_tsv
    TO_EXPORT.each do |t|
      cols = SPECIAL_COLS[t] || t.to_s.classify.constantize.column_names.join(",")
      cols_with_table_name = cols.split(",").collect{|c| "#{t}.#{c}"}.join(",")
      self.generate_csv(t.to_s,cols,
                       district.send(t).select(cols_with_table_name).to_sql)
    end
  end

  def export_content_csv
    CONTENT_ONLY.each do |t|
        cols = SPECIAL_COLS[t] || t.to_s.classify.constantize.column_names.join(",")
        cols_with_table_name = cols.split(",").collect{|c| "#{t}.#{c}"}.join(",")
        self.generate_content_csv(t.to_s,cols,
                         district.send(t).content_export.select(cols_with_table_name).to_sql)
    end
  end

  def export_content
    setup_directory(@content_dir)
    export_content_csv
  end

  def generate
    setup_directory
    csv_tsv
    self.generate_csv('users', 'id,district_user_id', "where (district_id = #{district.id}) or (district_id is null and username like '#{district.id}-%')")
    self.generate_csv('students', 'id,id_state',
                      Student.select("distinct id,id_state").where("district_id is null or district_id != #{district.id}").where(:id => @student_ids_in_use).to_sql,
                     "students_outside_district_with_content")
    export_assets
    #puts @student_ids_in_use.inspect
    #self.generate_csv('students_outside_district', 'id,id_state',)
    export_bat_and_sh
    self.generate_schema dir
    system "zip -j -qq " + dir.join("sims_export.zip").to_s + ' ' + dir.join("*").to_s
    dir.join("sims_export.zip").to_s
    #zip files
  end

  def export_assets
    assets = district.probe_definitions.collect(&:assets).flatten.compact |
      district.intervention_definitions.flatten.collect(&:assets).flatten.compact
    self.generate_csv('assets',Asset.column_names.join(","),"where id in (#{assets.collect(&:id).join(",")})") unless assets.blank?
  end

  def export_bat_and_sh
    curl_string = "curl -o sims_export.zip --user district_upload:PASSWORD #{district.url 'scripted/district_export'} -k"
    File.open(dir.join("sims_export.bat"), 'w') {|f| f.write(curl_string)}
    File.open(dir.join("sims_export.sh"), 'w') {|f| f.write(curl_string)}
  end

  def generate_schema dir
     File.open(dir.join("schema.txt"),"a+") do |f|
       @files.keys.sort.each do |table|
         f.write("#{table}\r\n")
         @files[table].split(',').each do |header|
           if table == "students_outside_district_with_content"
             obj = Student
           else
             obj=table.classify.constantize
           end
           col=obj.columns.find{|col| col.name == header}
           f.write("#{header} - #{col.type} - #{col.sql_type}\r\n" )
         end
         f.write("\r\n")
       end
     end

  end

  def generate_content_csv( table, headers, sql="where district_id = #{district.id}", filename = table)
    @files[filename]=headers
    sql = "select #{headers} from #{table} #{sql}" unless sql.match(/^select/i)
    CSV.open(@content_dir.join(filename + ".csv"), "w",:row_sep=>"\r\n") do |csv|
      csv << headers.split(',')
      select= headers.split(',').collect{|h| "#{table}.#{h}"}.join(",")
      Student.connection.select_rows(sql).each do |row|
        puts row
        csv << row
      end
    end
    
  end

 

  def generate_csv( table, headers, sql="where district_id = #{district.id}", filename = table)
    @files[filename]=headers
    sql = "select #{headers} from #{table} #{sql}" unless sql.match(/^select/i)
    CSV.open(dir.join(filename + ".tsv"), "w",:row_sep=>" |\r\n",:col_sep =>"\t" ) do |tsv|
    CSV.open(dir.join(filename + ".csv"), "w",:row_sep=>"\r\n") do |csv|
      csv << headers.split(',')
      tsv << headers.split(',')
      student_id_index = headers.split(',').index("student_id")
      select= headers.split(',').collect{|h| "#{table}.#{h}"}.join(",")
      Student.connection.select_rows(sql).each do |row|
        @student_ids_in_use << row[student_id_index] if student_id_index
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
      puts "bulk insert #{table} from \"#{dir.join(table+'.tsv')}\""
      puts "with ( ROWTERMINATOR = '\\n', FIELDTERMINATOR ='\\t', FIRSTROW=2)"
    end
  end
end
