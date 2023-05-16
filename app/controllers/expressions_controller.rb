# frozen_string_literal: true

class ExpressionsController < ApplicationController
  before_action :set_expression, only: %i[show edit update destroy]
  before_action :require_login, only: %i[new create]
  before_action :require_authority, only: %i[edit update destroy]

  # GET /expressions or /expressions.json
  # def index
  #   @expressions = Expression.all
  # end

  # GET /expressions/1 or /expressions/1.json
  def show
    if @expression.user_id.nil?
      @list = session[:list_url]
      @user = current_user
      store_location
    elsif logged_in?
      if @expression.user_id == current_user.id
        @list = session[:list_url]
        @user = current_user
        store_location
      else
        flash[:error] = '権限がないため閲覧できません'
        redirect_back_or_default
      end
    else
      flash[:error] = 'ログインが必要です'
      redirect_back_or_default
    end
  end

  # GET /expressions/new
  def new; end

  # GET /expressions/1/edit
  def edit; end

  # POST /expressions or /expressions.json
  def create
    @expression = Expression.new(expression_params)
    @expression.user_id = current_user.id
    @expression.tags = Tag.find_tags_object(@expression.tags)

    if @expression.save
      redirect_to expression_url(@expression), notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expressions/1 or /expressions/1.json
  def update
    if @expression.update(expression_params)
      redirect_to expression_url(@expression), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /expressions/1 or /expressions/1.json
  def destroy
    expression = @expression.next(session[:list_url], current_user) || @expression.previous(session[:list_url], current_user)

    @expression.destroy

    if expression
      redirect_to expression_path(expression), notice: t('.success')
    else
      redirect_to root_path, notice: t('.success')
    end
  end

  private

  def require_login
    return if logged_in?

    previous_page = session[:forwarding_url]
    store_location
    flash[:error] = 'ログインが必要です'
    redirect_to(previous_page || root_path)
  end

  def require_authority
    if logged_in?
      unless @expression.user_id == current_user.id
        flash[:error] = '権限がありません'
        redirect_back_or_default
      end
    else
      flash[:error] = 'ログインが必要です'
      redirect_back_or_default
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expression
    @expression = Expression.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expression_params
    params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }],
                                                   tags_attributes: %i[id name])
  end
end
