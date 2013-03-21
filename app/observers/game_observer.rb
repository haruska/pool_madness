class GameObserver < ActiveRecord::Observer
  observe Game

  def after_update(game)
    BracketScores.perform_async

    expire_action "/admin/games"
    expire_action "/public/games"

    Bracket.all.each do |bracket|
      expire_action "/brackets/#{bracket.id}"
      expire_action "/public/brackets/#{bracket.user.id}"
    end
  end

  private

  def controller
    @controller ||= ActionController::Base.new
  end

  def expire_action(action)
    controller.send(:expire_action, action)
  end
end
