class PagesController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_user!, only: [:graphql]

  def home
    respond_to { |f| f.html { render layout: "pages" } }
  end

  def graphql
    query_string = params[:query]
    query_variables = params[:variables]

    result = GraphqlSchema.execute(
        query_string,
        variables: query_variables,
        context: {
            current_user: current_user,
            current_ability: current_ability,
            optics_agent: env[:optics_agent].with_document(query_string)
        }
    )

    render json: result
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
