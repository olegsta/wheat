FactoryGirl.define do
  factory :message do
    correspondence_id 1
body "MyText"
user_id 1
message_type "MyString"
  end

end
