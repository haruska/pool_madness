module Admin::BracketsHelper
  def paid_to?(bracket)
    if bracket.stripe_charge_id.present?
      "Credit Card"
    elsif bracket.payment_collector.present?
      bracket.payment_collector.name
    else
      'Unknown'
    end
  end
end
