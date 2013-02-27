class ChargesController < ApplicationController
  load_and_authorize_resource :user, :except => [:create]
  load_and_authorize_resource :charge, :through => :user, :shallow => true, :except => [:create]

  def index
  end

  def create
    if params[:secret] == ENV['BITCOIN_CALLBACK_SECRET']
      order = JSON::parse(request.body.read)['order']
      if order['status'] == 'completed'
        charge = Charge.new
        charge.order_id = order['id']
        charge.completed_at = Time.parse(order['completed_at']) rescue nil
        charge.amount = order['total_native']['cents'].to_i
        charge.transaction_hash = order['transaction']['hash']

        bracket = Bracket.find_by_id(order['custom'])
        if bracket.present?
          charge.bracket = bracket
        else
          logger.error("Received order that was payment from non-existent bracket id: #{order['id']}")
        end

        charge.save!

      else
        logger.error("Received canceled order #{order['id']} for bracket id: #{order['custom']}")
      end

      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 404
    end
  end
end
