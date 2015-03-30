class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_brackets
  before_action :find_pool

  def create
    # Get the credit card details submitted by the form
    token = charge_params[:stripeToken]

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      Stripe::Charge.create(
        amount: amount, # amount in cents, again
        currency: "usd",
        source: token,
        description: "#{@brackets.size} bracket(s) in the pool #{@pool.name} at PoolMadness",
        statement_descriptor: "PoolMadness Brackets",
        metadata: { bracket_ids: @brackets.map(&:id).to_s, email: current_user.email }
      )

      @brackets.each(&:paid!)
      flash[:success] = "Charge Successful"

    rescue Stripe::CardError => e
      # The card has been declined
      flash[:error] = e.message
    end

    redirect_to pool_brackets_path(@pool)
  end

  private

  def find_brackets
    @brackets = current_user.brackets.where(id: charge_params[:bracket_ids]).to_a

    if @brackets.empty?
      flash[:error] = "There was a problem charging your credit card"
      redirect_to root_path
    end
  end

  def find_pool
    @pool = @brackets.first.pool
  end

  def amount
    @brackets.size * @pool.entry_fee
  end

  def charge_params
    params.permit(:stripeToken, bracket_ids: [])
  end
end
