class ThingsVersion < ActiveRecord::Base
  belongs_to :version
  belongs_to :thing, polymorphic: true
end
