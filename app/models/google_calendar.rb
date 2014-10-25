class GoogleCalendar < ActiveRecord::Base
  belongs_to :user
  has_many :events, as: :calendar
end
