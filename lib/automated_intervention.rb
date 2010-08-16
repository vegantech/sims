class AutomatedIntervention

  FORMAT="district_student_id,intervention_definition_id,start_date"

  def initialize file,district
    @count=0
    @messages = []
    @file = file.filename
  end

  def import
    @messages << "Did nothing"
    process_file
    messages
  end

  def messages
    @messages.join("\n<br />")
  end

  

  private
  def process_file
    check_headers or return false
  end

  def check_headers
    head=`head -n 1 #{@file}`.strip
    puts head

    if head == FORMAT
      true
    else
      @messages << "Invalid headers: They must be #{FORMAT}" 
      false
    end
  end

  def process_row
    check_for_duplicate
  end

  def check_for_duplicate
  end

  

end
