# This model represents a deduplicated model for a version.
#
# This should be used for large fields, e.g. the text of a paper, that may or
# may not change across versions.
#
# This model works by having many versions, and a `belongs_to` relation on
# version. This `text_id` on version is copied when creating a new version. We
# then use a copy-on-write system to create a new text if the text is updated.

class Text < ActiveRecord::Base
  has_many :versions
  before_update :copy_on_write
  before_update :prevent_editing_old_content

  def shared?
    versions.count > 1
  end

  private

  # Only allow editing the latest version
  def prevent_editing_old_content
    raise ActiveRecord::ReadOnlyRecord if shared? || !versions.first.latest?
  end

  def copy_on_write
    return unless shared?
    # Get the original attributes (currently stored in the db) to duplicate
    attrs = attributes.dup.merge(changed_attributes).except('id')
    dup = self.class.create!(attrs)
    paper = versions.first.paper # All the versions have the same paper, so just grab the first
    # Update all the old versions to point to this copy
    Version.where.not(id: paper.latest_version_id).update_all(text_id: dup.id)
  end
end
