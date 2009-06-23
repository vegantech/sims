# == Schema Information
# Schema version: 20090623023153
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
end
