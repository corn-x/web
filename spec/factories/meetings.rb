FactoryGirl.define do
  factory :scheduled_meeting, class: Meeting do
    # name "MyString"
    # time_ranges "MyString"
    # team nil
    # creator nil
    # where "MyString"
    # description "MyText"
    start_time "2014-10-24 23:30:29"
    end_time "2014-10-24 23:30:29"
  end
  factory :unscheduled_meeting, class: Meeting do
    # name "MyString"
    # time_ranges "MyString"
    # team nil
    # creator nil
    # where "MyString"
    # description "MyText"
    start_time nil
    end_time nil
  end
end
