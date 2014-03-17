class StripesController < ApplicationController
  load_and_authorize_resource :user, :except => [:create]

  def index
    @stripes = Stripe::Charge.all(:customer => @user.stripe_customer.id, :count => 100).data
  end

  def create
    bracket = Bracket.find(params[:bracket_id])

    customer = current_user.stripe_customer

    customer.card = params[:stripeToken]
    customer.save

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => 1061, #Amount in cents ($10.00)
        :description => "id: #{bracket.id}",
        :currency    => 'usd'
    )

    bracket.stripe_charge_id = charge.id
    bracket.save

    bracket.payment_received!

    redirect_to bracket, :notice => "Payment of $10.61 was successful."

  rescue Stripe::CardError => e
    redirect_to bracket, :alert => e.message
  end
end