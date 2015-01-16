class GameObserver < ActiveRecord::Observer
  observe Game

  def after_update(_game)
    BracketScores.perform_async

    expire_action "/admin/games"
    expire_action "/public/games"

    Bracket.all.each do |bracket|
      expire_action "/brackets/#{bracket.id}"
      expire_action "/public/brackets/#{bracket.user.id}"
    end

    Rails.cache.delete("views/all_brackets")
    Bracket.select("id").all.each { |b| Rails.cache.delete("views/bracket-show-#{b.id}") }
  end

  private

  def controller
    @controller ||= ActionController::Base.new
  end

  def expire_action(action)
    controller.send(:expire_action, action)
  end
end
