class User < ActiveRecord::Base
  has_many :google_calendars
  has_many :team_memberships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  #validations
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true


  def self.authenticate_with_authentication_token(token)
    User.find_by_authentication_token!(token)
  end

  def busy?(start_time, end_time)
    start_time +=1.minute
    end_time -= 1.minute
    events =[]

    self.google_calendars.each do |calendar|
      calendar.get_events
      events += calendar.events.where('(start_time <= ? and end_time >= ?) or (start_time >= ? and end_time <= ?) or (start_time <= ? and end_time >= ?) or (start_time <= ? and end_time >= ?)',start_time,start_time,start_time,end_time,end_time,end_time,start_time,end_time)
    end
    !events.empty?
  end

  def slice_times(time_ranges)
    times = []
    time_ranges.each do |time_range|
      google_calendars.each do |calendar|
        calendar.events.each do |event|
          if time_range.cover?(event.start_time)
            times << event.start_time
            if time_range.cover?(event.end_time)
              times << event.end_time
            else
              times << time_range.end
            end
          else
            if time_range.cover?(event.end_time)
              times << time_range.begin
              times << event.end_time
            end
          end
        end
      end
    end
    times
  end
end
