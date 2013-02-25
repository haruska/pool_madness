class ChargesController < ApplicationController
  load_and_authorize_resource :user

  def index
    @charges = Stripe::Charge.all(:customer => @user.stripe_customer.id, :count => 100).data
  end

  def create
    bracket = Bracket.find(params[:bracket_id])

    customer = @user.stripe_customer

    customer.card = params[:stripeToken]
    customer.save

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => 1000, #Amount in cents ($10.00)
        :description => "id: #{bracket.id}",
        :currency    => 'usd'
    )

    bracket.stripe_charge_id = charge.id
    bracket.save

    redirect_to bracket, :notice => "Payment of $10.00 was successful."

  rescue Stripe::CardError => e
    redirect_to bracket, :error => e.message
  end
end
