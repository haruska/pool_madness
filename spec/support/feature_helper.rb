# -*- encoding : utf-8 -*-
module FeatureHelper
  def pause_and_open_page(*args)
    Launchy.open(current_url)
    `echo "#{args.join(',')}" | pbcopy`
    binding.pry
  end
end
