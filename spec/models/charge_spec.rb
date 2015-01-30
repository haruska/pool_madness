require "spec_helper"

describe Charge, type: :model do
  it { should belong_to(:bracket) }
end
