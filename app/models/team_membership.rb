class TeamMembership < ActiveRecord::Base
  INVITATION='invitation'
  MANAGER='manager'
  MEMBER='member'
  belongs_to :user
  belongs_to :team
end
