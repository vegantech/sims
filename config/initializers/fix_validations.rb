class ActiveRecord::Errors 
  #a suggested fix from http://stackoverflow.com/questions/2067945/issues-with-displaying-validation-messages-with-nested-forms-rails-2-3
  def errors_hash 
    return @errors 
  end 
end
