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
end
