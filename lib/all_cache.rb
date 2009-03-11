module AllCache

  def self.included(klass)
    #initialize class variable
    
    klass.send :after_save, :reset_all_cache
    klass.send :after_destroy, :reset_all_cache
     
    klass.extend ClassMethods
  end

  def reset_all_cache
     self.class.reset_all_cache
  end
  
  module ClassMethods
    @@all_cache = nil
    def reset_all_cache
      #need order 
      if class_variable_defined? "@@all_cache_order"
        @@all_cache = find(:all, :order =>class_variable_get("@@all_cache_order"))
      else
        @@all_cache = find(:all)
      end
    end

    def all_cache
      @@all_cache = self.reset_all_cache
    end
 
  end
end
