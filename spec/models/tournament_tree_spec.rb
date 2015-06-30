require "spec_helper"

describe TournamentTree, type: :model do
  # let(:tournament) { create(:march_madness_tournament, :with_participants) }
  # subject { tournament.tree }
  #
  # describe "initialization" do
  #   it "can be initialized with just a depth (total rounds)" do
  #     tree = TournamentTree.new(6)
  #     expect(tree.class).to eq(TournamentTree)
  #     expect(tree.at(1).class).to eq(Game)
  #   end
  #
  #   it "can be initialized with a depth and a node_class" do
  #     tree = TournamentTree.new(6, node_class: BinaryDecisionTree::Node)
  #     expect(tree.class).to eq(TournamentTree)
  #     expect(tree.at(1).class).to eq(BinaryDecisionTree::Node)
  #   end
  #
  #   it "can be initialized with a Tournament" do
  #     tree = TournamentTree.new(tournament)
  #     expect(tree.class).to eq(TournamentTree)
  #     expect(tree.at(1).class).to eq(GameNode)
  #     expect(tree.tournament).to eq(tournament)
  #   end
  # end
  #
  # it "knows what tournament it references" do
  #   expect(subject.tournament).to eq(tournament)
  # end
  #
  # it "has GameNode children instead of Nodes" do
  #   subject.size.times do |i|
  #     next if i == 0
  #     expect(subject.at(i)).to be_a(GameNode)
  #   end
  # end
  #
  # it "has an all games mask" do
  #   mask = subject.all_games_mask
  #
  #   subject.size.times do |i|
  #     next if i == 0
  #     expect(mask & 1 << i).to be > 0
  #   end
  #
  #   expect(mask & 1 << (subject.size + 1)).to eq(0)
  #   expect(mask & 1).to eq(0)
  # end
  #
  # context "updating a game" do
  #   let(:game) { subject.at(32) }
  #
  #   it "is based on the child games' values" do
  #     subject.update_game(game.slot, game.first_participant_slot)
  #     expect(game.decision).to eq(GameNode::LEFT)
  #
  #     subject.update_game(game.slot, game.second_participant_slot)
  #     expect(game.decision).to eq(GameNode::RIGHT)
  #   end
  #
  #   it "makes no decision if team is not one of the child games' values" do
  #     subject.update_game(game.slot, 300)
  #
  #     expect(game.decision).to be_nil
  #   end
  #
  #   it "updates to no decision if nil passed in" do
  #     subject.update_game(game.slot, nil)
  #
  #     expect(game.decision).to be_nil
  #   end
  # end
  #
  # context "completed tournament" do
  #   subject { create(:completed_tournament).tree }
  #   let(:marshalled_tree) { BinaryDecisionTree::MarshalledTree.from_tree(subject) }
  #
  #   it "can marshal itself" do
  #     expect(subject.marshal.decisions).to eq(marshalled_tree.decisions)
  #     expect(subject.marshal.mask).to eq(marshalled_tree.mask)
  #   end
  # end
  #
  # context "round for" do
  #   it "finds all games for a given round" do
  #     (1..6).each do |round|
  #       depth = (0..7).to_a.reverse[round]
  #       games = subject.round_for(round)
  #
  #       expect(games.size).to eq(2**(depth - 1))
  #       games.each { |game| expect(game.round).to eq(round) }
  #     end
  #   end
  # end
end
