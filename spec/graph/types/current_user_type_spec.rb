require "rails_helper"

RSpec.describe Types::CurrentUserType do
  subject { Types::CurrentUserType }

  context "fields" do
    let(:fields) { %w[model_id email name admin] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
