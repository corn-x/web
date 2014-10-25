class User < ActiveRecord::Base
  has_many :google_calendars
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

  def slice_times
    times = []
    self.google_calendars.each do |calendar|
      calendar.events.each do |event|
        times += event.start_time
        times += event.end_time
      end
    end
    times
  end
end
