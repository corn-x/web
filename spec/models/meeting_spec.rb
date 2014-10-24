require 'rails_helper'

RSpec.describe Meeting, :type => :model do
  it "returns scheduled status correctly" do
    scheduled = build(:scheduled_meeting)
    expect(scheduled.scheduled?).to be true
    unscheduled = build(:unscheduled_meeting)
    expect(unscheduled.scheduled?).not_to be true
  end
end
