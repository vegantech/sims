module ControllerRights

  def self.included(klass)
    klass.extend(ClassMethods)
  end
  module ClassMethods      

     
  end
private    
  
  def action_group_for_current_action
    if self.class.write_actions.include?(action_name)
      'write_access'
    elsif self.class.read_actions.include?(action_name)
      #put in the defaults here,   override this and call super in individual controllers
      "read_access"
    else
      nil
    end
  end


  def to_s
    self.class.to_s.titleize.split(" Controller").first
  end

  def read_actions
     ['index', 'select', 'show', 'preview', 'read' , 'raw', 'part']
  end

  def write_actions
    ['create', 'update', 'destroy', 'new', 'edit', 'move', 'disable', 'disable_all', 'resend']
  end

end
