module Devise
  module LegacyPassword
    def valid_password?(password)
      if self.passwordhash.present?
        if legacy_hashes(password).include?(self.passwordhash_before_type_cast.downcase[0..39])
          self.password = password
          self.passwordhash = nil
          self.salt = nil
          self.sneaky_save
          return true
        else
          super(password)
        end
      else
        if reset_on_district_key?(password)
          self.send_reset_password_instructions(true) and raise Devise::ChangingPasswordInsteadOfFailedLogin
        else
          super(password)
        end
      end
    end

    def reset_password!(new_password, new_password_confirmation)
      self.passwordhash = nil
      self.salt = nil
      super
    end

    def password=(new_password)
      super
      if new_password.present?
        self.passwordhash = nil
        self.salt = nil
      end
    end


    private
    def self.legacy_encrypted_password(password, salt = nil, district_key = nil)
      Digest::SHA1.hexdigest("#{password.downcase}#{district_key}#{salt}")
    end

    def legacy_hashes(password)
      [district.try(:key),district.try(:previous_key),""].compact.collect{|k| Devise::LegacyPassword.legacy_encrypted_password(password, self.salt,k)}
    end

    def reset_on_district_key?(password)
      self.email.present? && self.passwordhash.blank? && self.encrypted_password.blank? && district.key.presence == password
    end
  end
end
