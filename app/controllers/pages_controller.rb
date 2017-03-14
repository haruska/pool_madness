class PagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_user!

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
          optics_agent: env[:optics_agent].try(:with_document, query_string)
        }
    )

    render json: result
  end
end
