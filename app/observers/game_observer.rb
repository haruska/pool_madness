class GameObserver < ActiveRecord::Observer
  observe Game

  def after_update(game)
    expire_action "/admin/games"
    expire_action "/public/games"

    expire_action "/admin/brackets"
    expire_action "/public/brackets"

    Bracket.all.each do |bracket|
      expire_action "/brackets/#{bracket.id}"
      expire_action "/brackets/#{bracket.id}/printable"
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
