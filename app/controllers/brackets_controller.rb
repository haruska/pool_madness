class BracketsController < ApplicationController
  load_and_authorize_resource

  caches_action :index, :layout => false, :cache_path => :index_cache_path.to_proc
  caches_action :show,  :layout => false, :cache_path => Proc.new {|c| "/brackets/#{c.params[:id]}"}
  #caches_action :printable, :layout => false, :cache_path => Proc.new {|c| "/brackets/#{c.params[:id]}/printable"}

  layout 'bracket', :except => [:index]


  def index
    if Pool.started?
      @brackets.sort_by! {|x| [x.points, x.possible_points]}
      @brackets.reverse!
    else
      @brackets.sort_by! {|x| [[:ok, :unpaid, :incomplete].index(x.status), x.name]}
    end
  end

  def show
  end

  def printable
    render :layout => false
  end

  def create
    if @bracket.save
      redirect_to edit_bracket_path(@bracket)
    else
      redirect_to root_path, :alert => 'Problem creating a new bracket. Please try again.'
    end
  end

  def update
    if params[:bracket][:pending_payment]
      @bracket.bitcoin_payment_submited!
      flash[:notice] = "Thank you. Your bitcoin payment is being processed."
      render :nothing => true
    else
      if @bracket.update_attributes(params[:bracket])
        redirect_to @bracket, :notice => 'Bracket Saved'
      else
        flash.now[:alert] = 'Problem saving bracket. Please try again'
        render :edit
      end
    end
  end

  def destroy
    @bracket.destroy
    redirect_to root_path, :notice => 'Bracket Destroyed'
  end

  def current_user_bracket_ids
    ids = current_user.brackets.select(:id).all.collect(&:id)
    render :json => ids.to_json
  end

  def index_cache_path
    if Pool.started?
      '/public/brackets'
    else
      current_user.has_role?(:admin) ? '/admin/brackets' : "/public/brackets/#{current_user.id}"
    end
  end
end
