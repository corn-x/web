class Meeting < ActiveRecord::Base
  belongs_to :team
  belongs_to :creator, class_name: 'User'
  serialize :time_ranges, Array

  def scheduled?
    !self.start_time.nil? and !self.end_time.nil?
  end

  def solve
    users = team.team_memberships.map { |tm| tm.user }
    slice_times = []
    users.each do |u|
      slice_times += u.slice_times(time_ranges)
    end
    time_ranges.each do |time_range|
      slice_times << time_range.begin
      slice_times << time_range.end
    end
    slice_times.sort
    slice_times = slice_times.uniq
    previous = slice_times.first
    events = []
    slice_times[1..-1].each do |time|
      unless time.day != previous.day
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
      end
      previous = time
    end
    events
  end
end