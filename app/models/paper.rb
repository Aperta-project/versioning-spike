class Paper < ActiveRecord::Base
  has_many :versions, dependent: :destroy
  belongs_to :latest_version, class_name: Version
  has_many :answers, through: :latest_version

  # Return true if this paper has no versions
  def no_versions?
    latest_version.nil?
  end
end
