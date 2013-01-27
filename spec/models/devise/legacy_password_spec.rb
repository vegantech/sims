require 'spec_helper'

describe Devise::LegacyPassword do
  describe 'legacy password is present' do
    let(:user) { fg=FactoryGirl.build(:user, :password => 'rspec123');fg.salt = 'salt';fg.passwordhash = Devise::LegacyPassword.legacy_encrypted_password('other123', 'salt');fg}

    specify {user.valid_password?('rspec123').should_not be}
    describe 'matches' do
      specify {user.valid_password?('other123').should be}
      it 'should reset the salt and hash' do
        user.valid_password?('other123')
        user.passwordhash.should be_nil
        user.salt.should be_nil
      end

      it 'should reset the salt and hash then the password attribute is changed' do
        user.password="dog"
        user.password_confirmation = "dog"

        user.valid_password?('dog').should be
        user.passwordhash.should be_nil
        user.salt.should be_nil
      end

      describe 'district keys' do
        let(:district) { FactoryGirl.build(:district, :key => 'key', :previous_key => 'old_key')}
        let(:user) { FactoryGirl.build(:user, :district => district,  :salt => 'salt')}

        it 'should match with the current key' do
          user.passwordhash = Devise::LegacyPassword.legacy_encrypted_password('other123', 'salt','key')
          user.valid_password?('other123').should be
        end

        it 'should match with the legacy key' do
          user.passwordhash = Devise::LegacyPassword.legacy_encrypted_password('other123', 'salt','old_key')
          user.valid_password?('other123').should be
        end

        it 'should match with blank key' do
          user.passwordhash = Devise::LegacyPassword.legacy_encrypted_password('other123', 'salt','')
          user.valid_password?('other123').should be
        end

      end



      it 'should set the new hash' do
        expect {
          user.valid_password?('other123')
        }.to change { user.encrypted_password }
      end
    end
    it 'should reset the salt and hash when changing the password' do
      user.reset_password!('newpass123', 'newpass123')
      user.passwordhash.should be_nil
      user.salt.should be_nil
      user.valid_password?('newpass123').should be
    end
  end

  describe 'legacy password is not present' do
    let(:user) { FactoryGirl.build(:user, :password => 'rspec123')}
    specify {user.valid_password?('rspec123').should be}
    specify {user.valid_password?('wrongrspec123').should_not be}
  end
end
