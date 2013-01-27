# == Schema Information
# Schema version: 20101101011500
#
# Table name: assets
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  url                   :string(255)
#  attachable_id         :integer(4)
#  attachable_type       :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer(4)
#  document_updated_at   :datetime
#

class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  has_attached_file :document

  def to_s
    "#{name} #{document.original_filename if document?}"
  end

  def self.duplicates
    find(:all, :group=>'name, url,attachable_id', :having => 'count(id)>1', :conditions => 'url <> "" and url is not null')
  end

  def broken?
    (document_file_name.present?  && !File.exists?(document.path)) ||
      (url.present? && !url_exists)
  end

  private
  def url_exists
    case url
     when /^\/file/
       File.exists?(File.join(Rails.root,url))
     when /^\/help/
      File.exists?(File.join(Rails.root,'app/views/help',"_#{url.split('/').last}.html.erb"))
     else
       false #go to it yourself
     end
  end
end
