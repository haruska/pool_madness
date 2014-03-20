class PickSweeper < ActionController::Caching::Sweeper
  observe Pick

  def after_update(pick)
    bracket = pick.bracket

    # Expire the index page now that we added a new product
    expire_action "/brackets/#{bracket.id}"
    expire_action "/admin/brackets"
    expire_action "/public/brackets"
    expire_action "/public/brackets/#{bracket.user.id}"

    Rails.cache.delete("sorted_four_#{bracket.id}")
  end

end