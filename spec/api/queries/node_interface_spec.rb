require "rails_helper"

RSpec.describe Queries::NodeInterface do
  let!(:pool) { create :pool }
  let!(:other_pool) { create :pool }

  describe "#object_from_id" do
    it "can get an object from its global id" do
      global_id = GraphQL::Relay::GlobalNodeIdentification.new.to_global_id("Pool", pool.id)
      expect(subject.object_from_id(global_id, {})).to eq(pool)

      global_id = GraphQL::Relay::GlobalNodeIdentification.new.to_global_id("Pool", other_pool.id)
      expect(subject.object_from_id(global_id, {})).to eq(other_pool)
    end
  end

  describe "#type_from_object" do
    it "can get an object's graphql type from the object" do
      expect(subject.type_from_object(pool)).to eq(Queries::PoolType)
    end
  end
end
