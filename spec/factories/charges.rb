# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge do
    order_id "MyString"
    completed_at "2013-02-26 20:34:19"
    amount 1
    transaction_hash "MyText"
    bracket_id 1
  end
end
