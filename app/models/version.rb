class Version < ActiveRecord::Base
  belongs_to :paper
  has_many :things_versions
  has_many :answers, source_type: Answer, source: :thing, through: :things_versions

  before_create :set_version_number
  after_create :set_paper_latest_version

  validates :number, uniqueness: {
    scope: :paper_id
  }

  private

  def set_version_number
    self.number = paper.versions.maximum(:number).try(:+, 1) || 0
  end

  def set_paper_latest_version
    paper.update_attribute(:latest_version_id, id)
  end
end
