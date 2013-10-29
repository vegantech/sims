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

  def cols_with_table_name(cols,table)
    cols.split(",").collect{|c| "#{table}.#{c}"}.join(",")
  end

  def csv_cols(assoc)
    SPECIAL_COLS[assoc] || assoc.to_s.classify.constantize.column_names.join(",")
  end

  def csv_tsv
    TO_EXPORT.each do |t|
      cols=csv_cols(t)
      self.generate_csv(t.to_s,cols,
                       district.send(t).select(cols_with_table_name(cols,t)).to_sql)
    end
  end

  def generate_users
    self.generate_csv('users', 'id,district_user_id', "where (district_id = #{district.id}) or (district_id is null and username like '#{district.id}-%')")
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
  end

  def generate_students
    self.generate_csv('students', 'id,id_state',
                      Student.select("distinct id,id_state").where("district_id is null or district_id != #{district.id}").where(:id => @student_ids_in_use).to_sql,
    "students_outside_district_with_content")
  end

  def zip
    system "zip -j -qq " + dir.join("sims_export.zip").to_s + ' ' + dir.join("*").to_s
    dir.join("sims_export.zip").to_s
  end

  def generate
    setup_directory
    csv_tsv
    generate_users
    generate_students
    export_assets
    export_bat_and_sh
    generate_schema
    zip
  end

  def district_asset_ids
    ( probe_definition_assets | intervention_definition_assets).flatten.compact.collect(&:id)
  end

  def probe_definition_assets
    district.probe_definitions.collect(&:assets)
  end

  def intervention_definition_assets
    district.intervention_definitions.collect(&:assets)
  end

  def export_assets
    generate_csv('assets',Asset.column_names.join(","),Asset.where(:id => district_asset_ids).to_sql)
  end

  def export_bat_and_sh
    curl_string = "curl -o sims_export.zip --user district_upload:PASSWORD #{district.url 'scripted/district_export'} -k"
    File.open(dir.join("sims_export.bat"), 'w') {|f| f.write(curl_string)}
    File.open(dir.join("sims_export.sh"), 'w') {|f| f.write(curl_string)}
  end


  def schema_obj(table)
    if table == "students_outside_district_with_content"
      obj = Student
    else
      obj=table.classify.constantize
    end
  end

  def schema_table(table,f)
    f.write("#{table}\r\n")
    @files[table].split(',').each do |header|
      col=schema_obj(table).columns.find{|col| col.name == header}
      f.write("#{header} - #{col.type} - #{col.sql_type}\r\n" )
    end
    f.write("\r\n")
  end

  def generate_schema
     File.open(dir.join("schema.txt"),"a+") do |f|
       @files.keys.sort.each {|table| schema_table table,f}
     end
  end

  def generate_csv_rows(csv,tsv,sql,student_id_index)
    Student.connection.select_rows(sql).each do |row|
      @student_ids_in_use << row[student_id_index] if student_id_index
      csv << row
      tsv << row.collect{|c| no_double_quotes(c)}
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
    split_headers = headers.split(',')
    student_id_index = split_headers.index("student_id")
    CSV.open(dir.join(filename + ".tsv"), "w",:row_sep=>" |\r\n",:col_sep =>"\t" ) do |tsv|
      CSV.open(dir.join(filename + ".csv"), "w",:row_sep=>"\r\n") do |csv|
        csv << split_headers
        tsv << split_headers
        generate_csv_rows(csv,tsv,sql,student_id_index)
      end;end
  end
end
