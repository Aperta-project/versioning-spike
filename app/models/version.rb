class Version < ActiveRecord::Base
  belongs_to :paper
  has_many :things_versions
  has_many :answers, source_type: Answer, source: :thing, through: :things_versions

  before_create :set_version_number
  after_create :copy_things
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

  def copy_things
    ThingsVersion.bulk_insert do |worker|
      # paper.latest_version is still the old version if this is called before set_paper_latest_version
      ThingsVersion.where(version: paper.latest_version).pluck(:thing_type, :thing_id).each do |thing_type, thing_id|
        worker.add(thing_type: thing_type, thing_id: thing_id, version_id: self.id)
      end
    end
  end
end
