
require "rails_helper"

RSpec.describe Mutations::RootType do
  subject { Mutations::RootType }

  context "fields" do
    let(:fields) { %w(create_charge) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
