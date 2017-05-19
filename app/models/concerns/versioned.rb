module Versioned
  extend ActiveSupport::Concern

  included do
    has_many :things_versions, as: :thing
    has_many :versions, through: :things_versions
    before_update :copy_on_write
    before_update :prevent_editing_old_content
  end

  def shared?
    versions.count > 1
  end

  private

  # Only allow editing the latest version
  def prevent_editing_old_content
    return false if shared? || !versions.first.latest?
  end

  def copy_on_write
    if shared?
      # Get the original attributes (currently stored in the db) to duplicate
      attrs = attributes.dup.merge(changed_attributes).except('id')
      dup = self.class.create!(attrs)
      paper = versions.first.paper # All the versions have the same paper, so just grab the first
      # Update all the old versions to point to this copy
      ThingsVersion
        .where(thing: self)
        .where.not(version: paper.latest_version)
        .update_all(thing_id: dup.id)
    end
  end
end
