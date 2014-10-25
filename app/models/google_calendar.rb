class GoogleCalendar < ActiveRecord::Base
  belongs_to :user
  has_many :events, as: :calendar
  alias_method :get_events, :events
  def events(start_time=nil,end_time=nil)
    sync(start_time,end_time) if pending_update?
    if start_time and end_time
      get_events.where('end_time > ? or start_time < ?',start_time,end_time) 
    else
      get_events
    end
  end

  def pending_update?
    !last_synced or last_synced < Time.now - 5.minutes  
  end

  def sync(start_time,end_time)
    oauth_wrapper = OauthWrapper.new

    calendar = oauth_wrapper.client.discovered_api('calendar', 'v3')
    oauth_wrapper.update_authorization(user)

    result = oauth_wrapper.execute(
      api_method: calendar.events.list,
      parameters: {
        'calendarId' => self.ext_id,
        'singleEvents' => 'true',
        'timeMin' => start_time.iso8601,
        'timeMax' => end_time.iso8601
      }
    )
    result.data.items.each do |event|
      dbevent = self.get_events.find_by_ext_id(event.id)
      if dbevent
        dbevent.update(start_time: event.start.dateTime, end_time: event.end.dateTime)
      else
        self.get_events.create!(ext_id: event.id, start_time: event.start.dateTime, end_time: event.end.dateTime)
      end
    end
    self.update(last_synced: Time.now)
    true
    
  end

end
