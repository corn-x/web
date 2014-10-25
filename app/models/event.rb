class Event < ActiveRecord::Base
  belongs_to :calendar, polymorphic: true
end
