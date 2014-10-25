class Meeting < ActiveRecord::Base
  belongs_to :team
  belongs_to :creator, class_name: 'User'
  serialize :time_ranges, Array

  def scheduled?
    !self.start_time.nil? and !self.end_time.nil?
  end

  def solve
    users = self.team.team_memberships.map { |tm| tm.user }
    slice_times = []
    users.each do |u|
      slice_times << u.slice_times(self.time_ranges)
    end
    slice_times.sort
    previous = slice_times.first
    events = []
    unless slice_times.empty?
      slice_times[1..-1].each do |time|
        collisions = 0
        users.each do |u|
          if u.busy?(previous, time)
            collisions += 1
          end
        end
        collisions *= 32
        collisions.to_s(16)
        color = '#' + collisions.to_s
        events << {title: collisions, start: previous, end: time, color: color}
        previous = time
      end
    end
    if events.empty?
      time_ranges.map do |time|
        events << {title: '0', start: time.begin, end: time.end, color: '#00ff00'}
      end
    end
    events
  end
end