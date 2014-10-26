require 'color'

class Meeting < ActiveRecord::Base
  belongs_to :team
  belongs_to :creator, class_name: 'User'
  serialize :time_ranges, Array

  validates :team, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true
  validate :time_ranges_must_be_valid, if: Proc.new { time_ranges.present? and time_ranges.count > 0 }

  def time_ranges=(ar)
    self['time_ranges'] = [] if ar.class != Array
    self['time_ranges'] = [] if ar == []
    self['time_ranges'] = ar if ar.first.class == Range
    self['time_ranges'] = ar.map {|a| (Time.parse a['start_time'])..(Time.parse a['end_time'])}
  end

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
    slice_times.uniq!
    slice_times.sort!
    previous = slice_times.first
    events = []
    slice_times[1..-1].each do |time|
      collisions = 0
      users.each do |u|
        if u.busy?(previous, time)
          collisions += 1
        end
      end
      hue = (1 - (collisions / users.size.to_f)) * 0.3
      color = '#' + Color::HSL.from_fraction(h = hue, s = 0.9, l = 0.7).to_rgb.hex
      events << { title: collisions, start: previous, end: time, color: color }
      previous = time
    end
    events
  end
  private
  def time_ranges_must_be_valid
    time_ranges.each do |tr|
      if tr.begin > tr.end
        errors.add(:time_ranges, 'begin time cannot be after end time')
      end
    end
  end
end

