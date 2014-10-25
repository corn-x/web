class Team < ActiveRecord::Base
  has_many :team_memberships
  has_many :meetings
  validates :name, uniqueness: true

  def members
    team_memberships.where(role: [TeamMembership::MEMBER, TeamMembership::MANAGER]).map{|tm| tm.user}
  end

  def managers
    team_memberships.where(role: TeamMembership::MANAGER).map{|tm| tm.user}
  end

  def invite(user)
    team_memberships.create(user: user, role: TeamMembership::INVITATION)
  end

  def add_member(user)
    team_memberships.create(user: user, role: TeamMembership::MEMBER)
  end
end
