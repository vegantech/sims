if RAILS_GEM_VERSION == '2.3.4'
  class Object
    def singleton_class
      metaclass
    end
  end

 ActiveRecord::Base.const_set 'UNASSIGNABLE_KEYS', ["id", "_delete", "_destroy"]

  class ActiveRecord::Base
    def _destroy
      _delete
    end

    private
    def has_delete_flag_with_destroy?(hash)
      hash['_delete'] =hash.delete('_destroy') if hash['_destroy']
      has_delete_flag_without_destroy?(hash)
    end
    alias_method_chain :has_delete_flag?, :destroy
  end
end

