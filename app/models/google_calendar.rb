class GoogleCalendar < ActiveRecord::Base
  belongs_to :user
  has_many :events, as: :calendar
  alias_method :get_events, :events
  def events(start_time,end_time)
    sync(start_time,end_time) if pending_update?
    get_events.where('end_time > ? or start_time < ?',start_time,end_time)
  end

  def pending_update?
    # !last_synced or last_synced < Time.now - 5.minutes
    true
  end

  def sync(start_time,end_time)
    client = Google::APIClient.new(
        :application_name => 'Example Ruby application',
        :application_version => '1.0.0'
    )

    calendar = client.discovered_api('calendar', 'v3')

    key = Google::APIClient::KeyUtils.load_from_pkcs12(Rails.root.join('config','key.p12'),'notasecret')
    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => %w(https://www.googleapis.com/auth/calendar email profile),
      :issuer => '36246022485-eoqhphlvqg627lo56t3or4r9m6hhu6gi@developer.gserviceaccount.com',
      :signing_key => key)
    client.authorization.access_token = self.user.access_token

    result = client.execute(:api_method => calendar.events.list,
      :parameters => {'calendarId' => 'lgurdek@gmail.com', 'singleEvents' => 'true', 'timeMin' => start_time.iso8601, 'timeMax' => end_time.iso8601},
      :authorization => client.authorization)
    puts result
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
