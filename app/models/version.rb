class Version < ActiveRecord::Base
  def self.has_many_versioned(what)
    join_table = "versioned_#{what.to_s.pluralize}".to_sym
    has_many join_table
    has_many what,
             (->(v) { v.latest? ? all : readonly }),
             through: join_table
  end

  belongs_to :paper
  has_many_versioned :answers

  before_create :set_version_number
  before_create :copy_fields
  after_create :copy_things
  after_create :set_paper_latest_version

  validates :number, uniqueness: {
    scope: :paper_id
  }

  default_scope { order(number: :asc) }

  def latest?
    paper.latest_version == self
  end

  private

  def set_version_number
    self.number = if paper.no_versions?
                    0
                  else
                    paper.versions.maximum(:number) + 1
                  end
  end

  def set_paper_latest_version
    paper.update_attribute(:latest_version_id, id)
  end

  def copy_fields
    return if paper.no_versions?
    [:title, :abstract].each do |thing|
      send("#{thing}=".to_sym, paper.latest_version.send(thing))
    end
  end

  def copy_things
    return if paper.latest_version_id.nil?

    VersionedAnswer.bulk_insert do |worker|
      # paper.latest_version is still the old version if this is called before set_paper_latest_version
      VersionedAnswer.where(version: paper.latest_version).pluck(:answer_id).each do |answer_id|
        worker.add(answer_id: answer_id, version_id: self.id)
      end
    end
  end
end
