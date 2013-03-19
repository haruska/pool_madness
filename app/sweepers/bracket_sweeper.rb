class BracketSweeper < ActionController::Caching::Sweeper
  observe Bracket


  def after_update(bracket)
    expire_cache_for(bracket)
  end

  def after_destroy(bracket)
    expire_cache_for(bracket)
  end

  private

  def expire_cache_for(bracket)
    # Expire the index page now that we added a new product
    expire_action "/brackets/#{bracket.id}"
    expire_action "/brackets/#{bracket.id}/printable"
    expire_action "/admin/brackets"
    expire_action "/public/brackets"
    expire_action "/public/brackets/#{bracket.user.id}"
  end
end