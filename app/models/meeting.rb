class Meeting < ActiveRecord::Base
  belongs_to :team
  belongs_to :creator, class_name: 'User'

  def scheduled?
    !self.start_time.nil? and !self.end_time.nil?
  end
end
