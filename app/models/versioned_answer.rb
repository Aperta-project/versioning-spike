class VersionedAnswer < ActiveRecord::Base
  belongs_to :answer
  belongs_to :version
end
