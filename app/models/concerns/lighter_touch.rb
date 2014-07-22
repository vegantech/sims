module LighterTouch
#  extend ActiveSupport::Concern
  def touch
    #I don't want validations to run, but I need to fix locking here!!!
    begin
      self.class.update_all( "updated_at = '#{Time.now.utc.to_s(:db)}'", "id = #{self.id}")
      rescue ActiveRecord::StatementInvalid
        logger.warn "Unable to get lock for touch in #{self.class.name}!"
    end
  end
end
