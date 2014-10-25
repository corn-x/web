class TeamMembership < ActiveRecord::Base
  INVITATION='invitation'
  MANAGER='manager'
  MEMBER='member'
  belongs_to :user
  belongs_to :team, autosave: true

  validates_uniqueness_of :user_id, :scope => [:team_id]
end
