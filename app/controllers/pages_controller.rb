class PagesController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token

  def home
    respond_to { |f| f.html { render layout: "pages" } }
  end

  def graphql
    render json: GraphqlSchema.execute(
      params[:query],
        variables: params[:variables],
        context: { current_user: current_user, current_ability: current_ability }
    )
  end

  if Rails.env.development?
    def authed_graphql
      render json: GraphqlSchema.execute(
        params[:query],
          variables: params[:variables],
          context: { current_user: current_user || User.last }
      )
    end
  end
end
