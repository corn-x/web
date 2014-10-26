require 'pry'
require 'icalendar'
require 'open-uri'
class GoogleCalendar < ActiveRecord::Base
  belongs_to :user
  has_many :events, as: :calendar
  def get_events(start_time=nil,end_time=nil)
    start_time ||= Time.now
    end_time ||= Time.now + 2.weeks
    sync(start_time,end_time) if pending_update?
    events.where('end_time > ? or start_time < ?',start_time,end_time) 

  end

  def pending_update?
    !last_synced or last_synced < Time.now - 5.minutes  
  end

  def sync(start_time,end_time)
    ical = open(ext_id).read
    cals = Icalendar.parse(ical)
    cal = cals.first

    cal.events.each do |e|
      puts e
      if !self.events.where(ext_id: e.uid) and !((e.dtend-e.dtstart) < 1.day) and e.dtstart.between(start_time,end_time)
        self.events.create(start_time: e.dtstart, end_time: e.dtend)
      end
    end
  end

end
