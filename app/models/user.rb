class User < ActiveRecord::Base
  has_many :google_calendars
  has_many :team_memberships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def busy?(start_time, end_time)
    events = []
    self.google_calendars.each do |calendar|
      events += calendar.events.where(
          '(start_time > ? or end_time < ?) or (start_time < ? and end_time > ?)',
          start_time, end_time, start_time, end_time
      )
    end
    !events.empty?
  end

  def slice_times(time_range)
    times = []
    self.google_calendars.each do |calendar|
      calendar.events.each do |event|
        if time_range.cover?(event.start_time)
          times += event.start_time
          if time_range.cover?(event.end_time)
            times += event.end_time
          else
            times += time_range.end
          end
        else
          if time_range.cover?(event.end_time)
            times += time_range.begin
            times += event.end_time
          end
        end
      end
    end
    times
  end
end
