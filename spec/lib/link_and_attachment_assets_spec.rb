require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class User
  include ::LinkAndAttachmentAssets
end

describe LinkAndAttachmentAssets do
  describe 'change timestamp on parent' do
    it 'should change the timestamp when assets are added' do
      u = Factory(:user)
      t = set_date_back_2_days(u)
      u.new_asset_attributes = ([url: 'http://www.example.com', name: 'Test Url'])
      u.save
      u.reload.updated_at.should be > t
    end

    it 'should not change the timestamp when assets are unchanged' do
      u = Factory(:user)
      u.new_asset_attributes = ([url: 'http://www.example.com', name: 'Test Url'])
      u.save
      t = set_date_back_2_days(u)
      u.existing_asset_attributes = ({u.assets.first.id.to_s => {url: 'http://www.example.com', name: 'Test Url'}})
      u.save
      u.reload.updated_at.to_time.should be_within(1).of(t.to_time)
    end

    it 'should  change the timestamp when assets are changed' do
      u = Factory(:user)
      u.new_asset_attributes = ([url: 'http://www.example.com', name: 'Test Url2'])
      u.save
      t = set_date_back_2_days(u)
      u.existing_asset_attributes = ({u.assets.first.id.to_s => {url: 'http://www.example.com', name: 'Test Url'}})
      u.save
      u.reload.updated_at.should be > t
    end

     it 'should  change the timestamp when assets are removed' do
      u = Factory(:user)
      u.new_asset_attributes = ([url: 'http://www.example.com', name: 'Test Url2'])
      u.save
      t = set_date_back_2_days(u)
      u.existing_asset_attributes = ({})
      u.save
      u.reload.updated_at.should be > t
    end
  end

  describe 'attachments' do
    it 'should save new attachments'
    it 'should update existing ones'do
      u = Factory(:user)
      u.new_asset_attributes = ([url: 'http://www.example.com', name: 'Test Url'])
      u.save
      a = u.assets.first
      a.should_receive(:save)
      u.existing_asset_attributes = ({u.assets.first.id.to_s => {url: 'http://www.example.com', name: 'Test Url2'}})
      u.save
    end
    it 'should remove ones that are no longer in existing'
    it 'should not save unchanged ones' do
      u = Factory(:user)
      u.new_asset_attributes = ([url: 'http://www.example.com', name: 'Test Url'])
      u.save
      a = u.assets.first
      a.should_not_receive(:save)
      u.existing_asset_attributes = ({u.assets.first.id.to_s => {url: 'http://www.example.com', name: 'Test Url'}})
      u.save
    end
  end

  def set_date_back_2_days(o)
    t = 2.days.ago
    o.class.update_all("updated_at = '#{t.to_s(:db)}' where id = #{o.id}")
    t
  end
end
