class TeamMembership < ActiveRecord::Base
  INVITATION='invitation'
  MANAGER='manager'
  belongs_to :user
  belongs_to :team
end
