class BracketObserver < ActiveRecord::Observer
  observe Bracket

  def after_create(bracket)
    expire_action "/public/brackets"
    expire_action "/admin/brackets"
    expire_action "/public/brackets/#{bracket.user.id}"
    Rails.cache.delete("sorted_four_#{bracket.id}")
  end

  def after_update(bracket)
    if Pool.started?
      expire_action "/public/brackets" if bracket.points_changed? || bracket.possible_points_changed? || bracket.best_possible_changed?
    else
      expire_action "/brackets/#{bracket.id}"
      expire_action "/admin/brackets"
      expire_action "/public/brackets/#{bracket.user.id}"
      Rails.cache.delete("sorted_four_#{bracket.id}")
    end
  end

  def after_destroy(bracket)
    expire_action "/public/brackets"
    expire_action "/brackets/#{bracket.id}"
    expire_action "/admin/brackets"
    expire_action "/public/brackets/#{bracket.user.id}"
    Rails.cache.delete("sorted_four_#{bracket.id}")
  end

  private

  def controller
    @controller ||= ActionController::Base.new
  end

  def expire_action(action)
    controller.send(:expire_action, action)
  end
end
