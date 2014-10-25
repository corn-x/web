class TeamsController < ApplicationController
  respond_to :json
  before_action :set_team, only: [:show, :edit, :update, :destroy, :accept_invitation, :reject_invitation, :add_member, :meetings, :members]
  before_action :require_manager, only: [:add_member]
  before_action :authenticate_from_token!

  def members
    @users = @team.members
    respond_with @users, template: 'users/index'
  end

  def meetings
    @meetings = @team.meetings
    respond_with @meetings, template: 'meetings/index'
  end

  def add_member
    invitations = add_member_params.map do |email|
      @team.team_memberships.create(user: User.find_by_email(email), role: 'invitation')
    end
    render json: invitations
  end

  def accept_invitation
    invitation = @team.team_memberships.where('user_id = ? and role = ?',current_user.id,TeamMembership::INVITATION).first
    if invitation
      invitation.update(role:'member')
      render json: nil, status: :ok
    else
      render json: nil, status: :not_found
    end
  end

  def my
    @teams = current_user.team_memberships.where('role = ? or role = ?',TeamMembership::MEMBER,TeamMembership::MANAGER).map do |tm| 
      #tm.team['role'] = tm.role
      tm.team
    end
    respond_with @teams, template: 'teams/index'
  end

  def reject_invitation
     invitation = @team.team_memberships.where('user_id = ? and role = ?',current_user.id,TeamMembership::INVITATION).first

    if invitation
      invitation.destroy
      render json: nil, status: :ok
    else
      render json: nil, status: :not_found
    end
  end

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # POST /teams
  # POST /teams.json
  def create
    @tm = current_user.team_memberships.new(role: TeamMembership::MANAGER)
    @team = @tm.build_team(team_params)

    respond_to do |format|
      if @tm.save
        format.html { redirect_to @tm.team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @tm.team }
      else
        format.html { render :new }
        format.json { render json: @tm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def require_manager
      @team.team_memberships.where(user: current_user, role: TeamMembership::MANAGER).count > 0
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end

    def add_member_params 
      params[:user_emails]
    end
end
