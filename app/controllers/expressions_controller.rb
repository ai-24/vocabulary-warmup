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
      @user = current_user
      session.delete(:forwarding_url)
      session[:forwarding_url] = root_path
    elsif logged_in?
      if @expression.user_id == current_user.id
        @user = current_user
      else
        redirect_to root_path, alert: t('.no_authority')
      end
    else
      redirect_to root_path, alert: t('not_logged_in')
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
    expression = @expression.next(current_user) || @expression.previous(current_user)

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

    store_location
    redirect_to root_path, flash: { unauthorized_access_to_create: t('not_logged_in') }
  end

  def require_authority
    if logged_in?
      redirect_to root_path, alert: t('no_authority') unless @expression.user_id == current_user.id
    else
      redirect_to root_path, alert: t('not_logged_in')
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
