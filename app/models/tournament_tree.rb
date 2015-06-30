class TournamentTree < BinaryDecisionTree::Tree
  alias_method :championship, :root
  attr_accessor :tournament

  def initialize(*args)
    if args[0].is_a?(Tournament)
      @tournament = args[0]
      super(@tournament.num_rounds, node_class: Game)
    else
      depth = args[0]
      options = args.size > 1 ? args[1] : { node_class: Game }
      super(depth, options)
    end
  end

  def self.unmarshal(tournament, decisions, mask)
    marshalled_tree = BinaryDecisionTree::MarshalledTree.new(tournament.num_rounds, decisions, mask)
    tournament_tree = marshalled_tree.to_tree(tree_class: TournamentTree)
    tournament_tree.tournament = tournament
    tournament_tree
  end

  def marshal
    BinaryDecisionTree::MarshalledTree.from_tree(self)
  end

  def all_games_mask
    mask = 0
    (1...size).each do |i|
      mask |= 1 << i
    end
    mask
  end

  def update_game(position, choice)
    self.mask |= 1 << position
    at(position).decision = choice
  end

  def round_for(round_number)
    depth_for = (1..depth).to_a.reverse.index(round_number) + 1
    slots = depth_for == 0 ? [1] : (2**(depth_for - 1)..(2**depth_for - 1)).to_a
    slots.map { |s| at(s) }
  end
end
